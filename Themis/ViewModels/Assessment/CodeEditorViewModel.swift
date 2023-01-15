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
    @Published var lassoMode = false
    @Published var feedbackForSelectionId = ""

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

    func addInlineHighlight(feedbackId: UUID) {
        if let file = selectedFile, let selectedSection = selectedSection {
            if (inlineHighlights.contains { $0.key == file.path }) {
                inlineHighlights[file.path]?.append(HighlightedRange(id: feedbackId.uuidString,
                                                                     range: selectedSection,
                                                                     color: UIColor.systemYellow,
                                                                     cornerRadius: 8))
            } else {
                inlineHighlights[file.path] = [HighlightedRange(id: feedbackId.uuidString,
                                                                range: selectedSection,
                                                                color: UIColor.systemYellow,
                                                                cornerRadius: 8)]
            }
        }
        undoManager.endUndoGrouping() /// undo group with addFeedback in AssessmentResult
    }
    
    func deleteInlineHighlight(feedback: AssessmentFeedback) {
        if let filePath = feedback.file?.path {
            inlineHighlights[filePath]?.removeAll { $0.id == feedback.id.uuidString }
        }
        
        if feedback.type == .inline {
            undoManager.endUndoGrouping() /// undo group with deleteFeedback in AssessmentResult
        }
    }
}
