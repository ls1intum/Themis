//
//  TextExerciseRendererViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 30.05.23.
//

import Foundation
import SwiftUI
import SharedModels
import CodeEditor
import Common

class TextExerciseRendererViewModel: ObservableObject {
    @Published var content: String? = "Loading..."
    @Published var fontSize: CGFloat = 18.0
    @Published var showAddFeedback = false
    @Published var showEditFeedback = false
    @Published var selectedFeedbackForEditingId = ""
    @Published var selectedFeedbackSuggestionId = ""
    @Published var selectedSection: NSRange?
    @Published var pencilMode = true
    @Published var isLoading = false
    @Published var inlineHighlights: [HighlightedRange] = [] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.inlineHighlights = oldValue
            }
        }
    }
    
    let undoManager = ThemisUndoManager.shared
    
    var wordCount: Int {
        let wordRegex = /[\w\u00C0-\u00ff]+/
        return content?.matches(of: wordRegex).count ?? 0
    }
    
    var charCount: Int {
        content?.count ?? 0
    }
    
    private var feedbackIdToBlockId: [Int: String] = [:]
    
    @MainActor
    func setup(basedOn participation: BaseParticipation?) {
        guard let textSubmission = participation?.submissions?.last?.baseSubmission.get(as: TextSubmission.self) else {
            log.error("Expected a TextSubmission but got \(type(of: participation?.submissions?.last?.baseSubmission)) instead")
            return
        }
        let feedbacks = participation?.results?.last?.feedbacks ?? []
        let blocks = textSubmission.blocks ?? []
        
        content = textSubmission.text ?? content
        setupHighlights(basedOn: blocks, and: feedbacks)
    }
    
    private func setupHighlights(basedOn blocks: [TextBlock], and feedbacks: [Feedback]) {
        blocks.forEach { block in
            guard let blockId = block.id,
                  let startIndex = block.startIndex,
                  let endIndex = block.endIndex,
                  let feedback = feedbacks.first(where: { $0.reference == block.id }),
                  startIndex < endIndex else {
                return
            }
            
            let range = NSRange(startIndex..<endIndex)
            let color = UIColor(.getHighlightColor(forCredits: feedback.credits ?? 0.0))
            
            inlineHighlights.append(HighlightedRange(id: blockId, range: range, color: color))
            feedbackIdToBlockId[feedback.id ?? -1] = blockId
        }
        undoManager.removeAllActions()
    }
        
    private func updateHighlightColor(for feedback: Feedback) {
        guard let feedbackId = feedback.id,
              let blockId = feedbackIdToBlockId[feedbackId],
              let oldHighlightIndex = inlineHighlights.firstIndex(where: { $0.id == blockId }) else {
            return
        }
        
        let oldHighlight = inlineHighlights[oldHighlightIndex]
        let newColor = UIColor(Color.getHighlightColor(forCredits: feedback.credits ?? 0.0))
        
        inlineHighlights[oldHighlightIndex] = HighlightedRange(id: oldHighlight.id, range: oldHighlight.range, color: newColor)
    }
}

extension TextExerciseRendererViewModel: FeedbackDelegate {
    func onFeedbackUpdate(_ feedback: AssessmentFeedback) {
        updateHighlightColor(for: feedback.baseFeedback)
    }
}
