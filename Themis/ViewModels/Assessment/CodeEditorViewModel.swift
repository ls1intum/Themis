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

class CodeEditorViewModel: ObservableObject {
    let undoManager = UndoManagerSingleton.shared.undoManager
    
    @Published var fileTree: [Node] = []
    @Published var openFiles: [Node] = []
    @Published var selectedFile: Node?
    @Published var editorFontSize = CGFloat(14) // Default font size
    @Published var selectedSection: NSRange?
    @Published var inlineHighlights: [String: [HighlightedRange]] = [:] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.inlineHighlights = oldValue
            }
        }
    }
    @Published var showAddFeedback = false
    @Published var showEditFeedback = false
    @Published var pencilMode = true
    @Published var feedbackForSelectionId = ""
    
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
    
    private var allFiles: [Node] {
        var files: [Node] = []
        var nodesToCheck = fileTree
        while !nodesToCheck.isEmpty {
            let currentNode = nodesToCheck.removeFirst()
            if currentNode.type == .file {
                files.append(currentNode)
            }
            if let children = currentNode.children {
                nodesToCheck.append(contentsOf: children)
            }
        }
        return files
    }
    
    @MainActor
    func openFile(file: Node, participationId: Int, templateParticipationId: Int) {
        if !openFiles.contains(where: { $0.path == file.path }) {
            openFiles.append(file)
            Task {
                await file.fetchCode(participationId: participationId)
                await file.calculateDiff(templateParticipationId: templateParticipationId)
            }
        }
        selectedFile = file
    }
    
    func closeFile(file: Node) {
        openFiles = openFiles.filter({ $0.path != file.path })
        selectedFile = openFiles.first
    }
    
    func initFileTree(participationId: Int) async {
        do {
            let files = try await ArtemisAPI.getFileNamesOfRepository(participationId: participationId)
            let node = ArtemisAPI.initFileTreeStructure(files: files)
            DispatchQueue.main.async {
                self.fileTree = node.children ?? []
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func addInlineHighlight(feedbackId: UUID) {
        if let file = selectedFile, let selectedSection = selectedSection {
            appendHighlight(feedbackId: feedbackId, range: selectedSection, path: file.path)
        }
            undoManager.endUndoGrouping() /// undo group with addFeedback in AssessmentResult
    }
    
    @MainActor
    func loadInlineHighlight(assessmentResult: AssessmentResult, participationId: Int) async {
        for i in 0..<assessmentResult.inlineFeedback.count {
            // extract file path
            let feedback = assessmentResult.inlineFeedback[i]
            // the reference is extracted from the text since it is more detailed (includes columns and multilines)
            if let text = feedback.text {
                let components = text.components(separatedBy: .whitespaces)
                let path = extractFilePath(textComponents: components)
                let lines = extractLines(textComponents: components)
                // assign the related file to the feedback (required for deleting)
                if let referencedFile = allFiles.first(where: { $0.path == path }) {
                    assessmentResult.assignFile(id: feedback.id, file: referencedFile)
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
    }
    
    func deleteInlineHighlight(feedback: AssessmentFeedback) {
        if let filePath = feedback.file?.path {
            let highlight = inlineHighlights[filePath]?.first(where: { $0.id == feedback.id.uuidString })
            scrollUtils.offsets = scrollUtils.offsets.filter({ $0.key != highlight?.range })
            inlineHighlights[filePath]?.removeAll { $0.id == feedback.id.uuidString }
        }
        
        if feedback.type == .inline {
            undoManager.endUndoGrouping() /// undo group with deleteFeedback in AssessmentResult
        }
    }
    
    private func appendHighlight(feedbackId: UUID, range: NSRange, path: String) {
        let highlightedRange = HighlightedRange(
            id: feedbackId.uuidString,
            range: range,
            color: UIColor.systemYellow,
            cornerRadius: 8
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
    
    private func assignFileToFeedback(assessmentResult: AssessmentResult, path: String, id: UUID) {
        if let referencedFile = allFiles.first(where: { $0.path == path }) {
            assessmentResult.assignFile(id: id, file: referencedFile)
        }
    }
    
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
