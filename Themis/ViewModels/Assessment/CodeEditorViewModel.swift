//
//  CodeEditorViewModel.swift
//  Themis
//
//  Created by Andreas Cselovszky on 27.11.22.
//

import Foundation
import UIKit
import CodeEditor

class CodeEditorViewModel: ObservableObject {
    @Published var fileTree: [Node] = []
    @Published var openFiles: [Node] = []
    @Published var selectedFile: Node?
    @Published var editorFontSize = CGFloat(14) // Default font size
    @Published var selectedSection: NSRange?
    @Published var inlineHighlights: [String: [HighlightedRange]] = [:]
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
    
    @MainActor
    func openFile(file: Node, participationId: Int, templateParticipationId: Int) {
        if !openFiles.contains(where: { $0.path == file.path }) {
            openFiles.append(file)
            Task {
                await file.fetchCode(participationId: participationId)
                if let (rangesAdded, rangesRemoved) = await file.calculateDiff(templateParticipationId: templateParticipationId) {
                    var ranges = [HighlightedRange]()
                    for range in rangesAdded {
                        print(range)
                        ranges.append(
                            HighlightedRange(
                                id: UUID().uuidString,
                                range: NSRange(range, in: file.code ?? ""),
                                color: UIColor.systemGreen,
                                cornerRadius: 8
                            )
                        )
                    }
                    for range in rangesRemoved {
                        ranges.append(
                            HighlightedRange(
                                id: UUID().uuidString,
                                range: NSRange(range, in: file.code ?? ""),
                                color: UIColor.systemRed,
                                cornerRadius: 8
                            )
                        )
                    }
                    if inlineHighlights.contains(where: { $0.key == file.path }) {
                        inlineHighlights[file.path]?.append(contentsOf: ranges)
                    } else {
                        inlineHighlights[file.path] = ranges
                    }
                }
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
            print(selectedSection)
            if (inlineHighlights.contains { $0.key == file.path }) {
                inlineHighlights[file.path]?.append(
                    HighlightedRange(
                        id: feedbackId.uuidString,
                        range: selectedSection,
                        color: UIColor.systemYellow,
                        cornerRadius: 8
                    )
                )
            } else {
                inlineHighlights[file.path] = [
                    HighlightedRange(
                        id: feedbackId.uuidString,
                        range: selectedSection,
                        color: UIColor.systemYellow,
                        cornerRadius: 8
                    )
                ]
            }
        }
    }
    
    func deleteInlineHighlight(feedback: AssessmentFeedback) {
        if let filePath = feedback.file?.path {
            let highlight = inlineHighlights[filePath]?.first(where: { $0.id == feedback.id.uuidString })
            scrollUtils.offsets = scrollUtils.offsets.filter({ $0.key != highlight?.range })
            inlineHighlights[filePath]?.removeAll { $0.id == feedback.id.uuidString }
        }
    }
}
