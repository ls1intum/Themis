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

class TextExerciseRendererViewModel: ExerciseRendererViewModel {
    @Published var content: String? = "Loading..."
    @Published var selectedSection: NSRange?
    @Published var inlineHighlights: [HighlightedRange] = [] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.inlineHighlights = oldValue
            }
        }
    }
        
    var wordCount: Int {
        let wordRegex = /[\w\u00C0-\u00ff]+/
        return content?.matches(of: wordRegex).count ?? 0
    }
    
    var charCount: Int {
        content?.count ?? 0
    }
    
    private var textAtSelectedSection: String? {
        guard let content,
              let selectedSection,
              let indexRange = Range(selectedSection, in: content) else {
            return nil
        }
        return String(content[indexRange])
    }
    
    /// Needed for creating new text blocks
    private var submissionId: Int?
    
    /// Sets this VM up based on the given participation and optional submission
    /// - Parameters:
    ///   - participation:
    ///   - submission: Optional. Only used if the participation parameter does not contain a submission (this occurs when starting a new random assessment, for example)
    @MainActor
    func setup(basedOn participation: BaseParticipation?, _ submission: BaseSubmission? = nil, _ assessmentResult: AssessmentResult) {
        var textSubmission = participation?.submissions?.last?.baseSubmission as? TextSubmission
            
        if textSubmission == nil { // no submission found in participation
            textSubmission = submission as? TextSubmission
        }
        
        guard let textSubmission else {
            log.error("Expected a TextSubmission but got \(type(of: participation?.submissions?.last?.baseSubmission)) and \(type(of: submission)) instead")
            return
        }
        
        let feedbacks = assessmentResult.inlineFeedback + assessmentResult.automaticFeedback
        let blocks = textSubmission.blocks ?? []
        inlineHighlights.removeAll()
        
        submissionId = textSubmission.id
        content = textSubmission.text ?? content
        setupHighlights(basedOn: blocks, and: feedbacks)
    }
    
    /// Generates a `TextFeedbackDetail` instance based on the available data. Some fields might be missing
    func generateIncompleteFeedbackDetail() -> TextFeedbackDetail {
        let block = TextBlock(submissionId: submissionId,
                              text: textAtSelectedSection,
                              startIndex: selectedSection?.lowerBound,
                              endIndex: selectedSection?.upperBound)
        return TextFeedbackDetail(block: block)
    }
    
    // MARK: - Highlight-related code
    private func setupHighlights(basedOn blocks: [TextBlock], and feedbacks: [AssessmentFeedback], shouldWipeUndo: Bool = true) {
        feedbacks.forEach { assessmentFeedback in
            guard let block = findBlock(for: assessmentFeedback, using: blocks),
                  let startIndex = block.startIndex,
                  let endIndex = block.endIndex,
                  startIndex < endIndex
            else {
                return
            }
            
            let range = NSRange(startIndex..<endIndex)
            let color = UIColor(.getHighlightColor(forCredits: assessmentFeedback.baseFeedback.credits ?? 0.0))
            let isSuggested = assessmentFeedback.baseFeedback.type?.isAutomatic ?? false
            
            inlineHighlights.append(HighlightedRange(id: assessmentFeedback.id, range: range, color: color, isSuggested: isSuggested))
        }
        
        if shouldWipeUndo {
            undoManager.removeAllActions()
        }
    }
    
    /// Attempts to find the corresponding block for the given AssessmentFeedback among the given blocks.
    /// If it fails, the `detail` property of AssessmentFeedback is used instead. The latter is useful for automatic feedbacks.
    private func findBlock(for assessmentFeedback: AssessmentFeedback, using blocks: [TextBlock]) -> TextBlock? {
        if let block = blocks.first(where: { $0.id == assessmentFeedback.baseFeedback.reference }) {
            return block
        } else {
            return (assessmentFeedback.detail as? TextFeedbackDetail)?.block
        }
    }
    
    private func updateHighlightColor(for feedback: AssessmentFeedback) {
        guard let oldHighlightIndex = inlineHighlights.firstIndex(where: { $0.id == feedback.id }) else {
            return
        }
        
        let oldHighlight = inlineHighlights[oldHighlightIndex]
        let newColor = UIColor(Color.getHighlightColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
        
        inlineHighlights[oldHighlightIndex] = HighlightedRange(id: oldHighlight.id, range: oldHighlight.range, color: newColor)
    }
    
    private func createHighlight(for feedback: AssessmentFeedback) {
        guard let block = (feedback.detail as? TextFeedbackDetail)?.block else {
            return
        }
        setupHighlights(basedOn: [block], and: [feedback], shouldWipeUndo: false)
        undoManager.endUndoGrouping() // undo group with addFeedback in AssessmentResult
    }
    
    private func deleteHighlight(for feedback: AssessmentFeedback) {
        inlineHighlights.removeAll(where: { $0.id == feedback.id })
        
        if feedback.scope == .inline {
            undoManager.endUndoGrouping() // undo group with deleteFeedback in AssessmentResult
        }
    }
    
    private func deleteHighlight(for suggestion: TextFeedbackSuggestion) {
        inlineHighlights.removeAll(where: { $0.id == suggestion.id })
        undoManager.endUndoGrouping()
    }
    
    private func replaceHighlight(for suggestion: TextFeedbackSuggestion, withHighlightFor feedback: AssessmentFeedback) {
        inlineHighlights.removeAll(where: { $0.id == suggestion.id })
        createHighlight(for: feedback)
    }
}

extension TextExerciseRendererViewModel: FeedbackDelegate {
    func onFeedbackCreation(_ feedback: AssessmentFeedback) {
        createHighlight(for: feedback)
    }
    
    func onFeedbackUpdate(_ feedback: AssessmentFeedback) {
        updateHighlightColor(for: feedback)
    }
    
    func onFeedbackDeletion(_ feedback: AssessmentFeedback) {
        deleteHighlight(for: feedback)
    }
    
    func onFeedbackSuggestionSelection(_ suggestion: any FeedbackSuggestion, _ feedback: AssessmentFeedback) {
        guard let suggestion = suggestion as? TextFeedbackSuggestion else {
            return
        }
        replaceHighlight(for: suggestion, withHighlightFor: feedback)
    }
    
    func onFeedbackSuggestionDiscard(_ suggestion: any FeedbackSuggestion) {
        guard let suggestion = suggestion as? TextFeedbackSuggestion else {
            return
        }
        deleteHighlight(for: suggestion)
    }
}
