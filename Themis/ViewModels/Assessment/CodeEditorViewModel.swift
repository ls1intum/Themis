//
//  CodeEditorViewModel.swift
//  Themis
//
//  Created by Andreas Cselovszky on 27.11.22.
//

import Foundation
import UIKit
import SwiftUI
import CodeEditor
import Common

class CodeEditorViewModel: ObservableObject {
    let undoManager = ThemisUndoManager.shared
    
    @Published var fileTree: [Node] = []
    @Published var openFiles: [Node] = []
    @Published var selectedFile: Node?
    @Published var editorFontSize: CGFloat = CodeEditor.defaultFontSize
    @Published var selectedSection: NSRange?
    @Published var inlineHighlights: [String: [HighlightedRange]] = [:] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.inlineHighlights = oldValue
            }
        }
    }
    @Published var isLoading = false
    @Published var showAddFeedback = false
    @Published var showEditFeedback = false
    @Published var pencilModeDisabled = true
    @Published var allowsInlineFeedbackOperations = true
    @Published var selectedFeedbackForEditingId = UUID()
    @Published var error: Error?
    @Published var feedbackSuggestions = [FeedbackSuggestion]()
    @Published var selectedFeedbackSuggestionId = ""
    
    var scrollUtils = ScrollUtils(range: nil, offsets: [:])
    
    var selectedSectionParsed: (NSRange, NSRange?)? {
        if let selectedFile = selectedFile, let selectedSection = selectedSection, let lines = selectedFile.lines {
            let fromLine = (lines.firstIndex { $0.contains(selectedSection.location) } ?? -1) + 1
            let toLine = (lines.firstIndex { $0.contains(selectedSection.location + selectedSection.length) } ?? -1) + 1
            let lineRange = NSRange(location: fromLine, length: toLine - fromLine)
            
            if (fromLine == toLine) && (fromLine != 0) {
                let fromColumn = (selectedSection.location - lines[fromLine - 1].location) + 1
                let toColumn = (selectedSection.location + selectedSection.length) - lines[toLine - 1].location
                let columnRange = NSRange(location: fromColumn, length: toColumn - fromColumn)
                return (lineRange, columnRange)
            }
            return (lineRange, nil)
        }
        return nil
    }
    
    var selectedFeedbackSuggestion: FeedbackSuggestion? {
        feedbackSuggestions.first { "\($0.id)" == selectedFeedbackSuggestionId }
    }
    
    private var allFiles: [Node] {
        var files: [Node] = []
        var nodesToCheck = fileTree
        nodesToCheck.forEach { nodesToCheck.append(contentsOf: $0.recursiveChildren ?? []) }
        while !nodesToCheck.isEmpty {
            let currentNode = nodesToCheck.removeFirst()
            if currentNode.type == .file {
                files.append(currentNode)
            }
        }
        return files
    }
    
    @MainActor
    func openFile(file: Node, participationId: Int, templateParticipationId: Int?) {
        if !openFiles.contains(where: { $0.path == file.path }) {
            openFiles.append(file)
            Task {
                await file.fetchCode(participationId: participationId)
                if let templateParticipationId {
                    await file.calculateDiff(templateParticipationId: templateParticipationId)
                }
            }
        }
        selectedFile = file
    }
    
    @MainActor
    func closeFile(file: Node) {
        openFiles = openFiles.filter({ $0.path != file.path })
        selectedFile = openFiles.first
    }
    
    /// Returns true if the given file is currently open in the code editor
    func isOpen(file: Node) -> Bool {
        file.path == selectedFile?.path
    }
    
    @MainActor
    func initFileTree(participationId: Int, repositoryType: RepositoryType) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let files = try await RepositoryServiceFactory.shared.getFileNamesOfRepository(participationId: participationId)
            let node = Node.initFileTreeStructure(files: files)
            self.fileTree = node.children ?? []
            self.openFiles = []
            self.selectedFile = nil
            self.allowsInlineFeedbackOperations = (repositoryType == .student)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    func getFeedbackSuggestions(participationId: Int, exerciseId: Int) async {
        do {
            self.feedbackSuggestions = try await ThemisAPI.getFeedbackSuggestions(exerciseId: exerciseId, participationId: participationId)
            log.info("Got \(self.feedbackSuggestions.count) feedback suggestions")
        } catch {
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    func addFeedbackSuggestionInlineHighlight(feedbackSuggestion: FeedbackSuggestion, feedbackId: UUID) {
        if let file = selectedFile, let code = file.code {
            guard let range = getLineRange(text: code, fromLine: feedbackSuggestion.fromLine, toLine: feedbackSuggestion.toLine) else {
                return
            }
            appendHighlight(feedbackId: feedbackId, range: range, path: file.path)
        }
    }
    
    private func getLineRange(text: String, fromLine: Int, toLine: Int) -> NSRange? {
        var count = 1
        var fromIndex: String.Index?
        var toDistance: Int = 0
        var offset = 0
        text.enumerateLines { line, stop in
            if count < fromLine {
                offset += text.distance(from: line.startIndex, to: line.endIndex) + 1
            }
            if count == fromLine {
                fromIndex = line.startIndex
            }
            if count >= fromLine && count < toLine {
                toDistance += text.distance(from: line.startIndex, to: line.endIndex) + 1
            }
            if count == toLine {
                stop = true
            }
            count += 1
        }
        guard var fromIndex else {
            return nil
        }
        fromIndex = text.index(fromIndex, offsetBy: offset)
        let toIndex = text.index(fromIndex, offsetBy: toDistance)
        
        return NSRange(text.lineRange(for: fromIndex...toIndex), in: text)
    }
    
    @MainActor
    func addInlineHighlight(feedbackId: UUID) {
        if let file = selectedFile, let selectedSection = selectedSection {
            appendHighlight(feedbackId: feedbackId, range: selectedSection, path: file.path)
        }
        undoManager.endUndoGrouping() // undo group with addFeedback in AssessmentResult
    }
    
    @MainActor
    func loadInlineHighlightsIfEmpty(assessmentResult: AssessmentResult, participationId: Int) async {
        guard inlineHighlights.isEmpty else {
            return
        }
        
        for feedback in assessmentResult.inlineFeedback {
            // the reference is extracted from the text since it is more detailed (includes columns and multilines)
            if let text = feedback.baseFeedback.text {
                let components = text.components(separatedBy: .whitespaces)
                let path = extractFilePath(textComponents: components)
                let lines = extractLines(textComponents: components)
                // assign the related file to the feedback (required for deleting)
                if let referencedFile = allFiles.first(where: { $0.path == path }) {
                    assign(file: referencedFile, tofeedbackWithId: feedback.id, on: assessmentResult)
                    // this is required because the lines of a file are only availabe after the code is fetched
                    await referencedFile.fetchCode(participationId: participationId)
                    // indicates a multiline highight
                    if components.count == 5 {
                        constructHighlight(file: referencedFile, lines: lines, id: feedback.id)
                    }
                    // indicates a single line highlight
                    if components.count == 7 {
                        let columns = extractColumns(textComponents: components)
                        constructHighlight(file: referencedFile, lines: lines, id: feedback.id, columns: columns)
                    }
                }
            }
        }
        undoManager.removeAllActions()
    }
    
    private func assign(file: Node, tofeedbackWithId feedbackId: UUID, on assessmentResult: AssessmentResult) {
        guard var feedback = assessmentResult.getFeedback(byId: feedbackId) else {
            return
        }
        
        var detail = ProgrammingFeedbackDetail()
        
        if let existingDetail = feedback.detail as? ProgrammingFeedbackDetail {
            detail = existingDetail // use existing detail to prevent overwriting
        }
        
        detail.file = file
        feedback.detail = detail
        assessmentResult.updateFeedback(feedback: feedback)
    }
    
    @MainActor
    func deleteInlineHighlight(feedback: AssessmentFeedback) {
        if let filePath = (feedback.detail as? ProgrammingFeedbackDetail)?.file?.path {
            let highlight = inlineHighlights[filePath]?.first(where: { $0.id == feedback.id })
            scrollUtils.offsets = scrollUtils.offsets.filter({ $0.key != highlight?.range })
            inlineHighlights[filePath]?.removeAll { $0.id == feedback.id }
        }
        
        if feedback.scope == .inline {
            undoManager.endUndoGrouping() // undo group with deleteFeedback in AssessmentResult
        }
    }
    
    @MainActor
    private func appendHighlight(feedbackId: UUID, range: NSRange, path: String) {
        let highlightedRange = HighlightedRange(
            id: feedbackId,
            range: range,
            color: UIColor(Color.neutralTextHighlight)
        )
        
        if (inlineHighlights.contains { $0.key == path }) {
            inlineHighlights[path]?.append(
                highlightedRange
            )
        } else {
            inlineHighlights[path] = [
                highlightedRange
            ]
        }
    }
    
    private func extractFilePath(textComponents: [String]) -> String {
        textComponents[1]
    }
    
    private func extractLines(textComponents: [String]) -> [Int] {
        textComponents[4].components(separatedBy: "-").map { Int($0) ?? 0 }
    }
    
    private func extractColumns(textComponents: [String]) -> [Int] {
        textComponents[6].components(separatedBy: "-").map { Int($0) ?? 0 }
    }
    
    @MainActor
    private func constructHighlight(file: Node, lines: [Int], id: UUID, columns: [Int]? = nil) {
        if let fileLines = file.lines {
            var range = NSRange(location: 0, length: 0)
            switch lines.count {
            // single line feedback with additional column reference
            case 1:
                let line = lines[0]
                if fileLines.count >= line, let columns = columns {
                    let leftCol = columns[0]
                    if columns.count == 1 {
                        // single column
                        let startIndex = fileLines[line - 1].location + leftCol - 1
                        range = NSRange(location: startIndex, length: 1)
                    } else {
                        // two columns
                        let rightCol = columns[1]
                        let startIndex = fileLines[line - 1].location + leftCol - 1
                        let endIndex = fileLines[line - 1].location + rightCol - 1
                        range = NSRange(location: startIndex, length: endIndex - startIndex)
                    }
                }
            // multiline feedback without column reference
            case 2:
                let startLine = lines[0]
                let endLine = lines[1]
                if fileLines.count >= endLine {
                    let startIndex = fileLines[startLine - 1].location
                    let endIndex = fileLines[endLine - 1].location + fileLines[endLine - 1].length
                    range = NSRange(location: startIndex, length: endIndex - startIndex)
                }
            default:
                return
            }
            appendHighlight(feedbackId: id, range: range, path: file.path)
        }
    }
}

extension CodeEditorViewModel: FeedbackDelegate {
    @MainActor
    func onFeedbackCreation(_ feedback: AssessmentFeedback) {
        addInlineHighlight(feedbackId: feedback.id)
    }
    
    @MainActor
    func onFeedbackDeletion(_ feedback: AssessmentFeedback) {
        deleteInlineHighlight(feedback: feedback)
    }
    
    @MainActor
    func onFeedbackSuggestionSelection(_ suggestion: FeedbackSuggestion, _ feedback: AssessmentFeedback) {
        addFeedbackSuggestionInlineHighlight(feedbackSuggestion: suggestion, feedbackId: feedback.id)
    }
    
    @MainActor
    func onFeedbackCellTap(_ feedback: AssessmentFeedback, participationId: Int?, templateParticipationId: Int?) {
        guard let file = (feedback.detail as? ProgrammingFeedbackDetail)?.file,
              let participationId,
              let templateParticipationId else {
            return
        }
        
        withAnimation {
            openFile(file: file, participationId: participationId, templateParticipationId: templateParticipationId)
        }
        
        scrollUtils.range = inlineHighlights[file.path]?.first { $0.id == feedback.id }?.range
    }
}
