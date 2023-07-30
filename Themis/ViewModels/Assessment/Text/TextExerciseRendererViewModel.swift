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
        
        let feedbacks = assessmentResult.inlineFeedback
        let blocks = textSubmission.blocks ?? []
        inlineHighlights.removeAll()
        
        submissionId = textSubmission.id
        content = textSubmission.text ?? content
        setupHighlights(basedOn: blocks, and: feedbacks)
    }
    
    private func setupHighlights(basedOn blocks: [TextBlock], and feedbacks: [AssessmentFeedback], shouldWipeUndo: Bool = true) {
        blocks.forEach { block in
            guard let startIndex = block.startIndex,
                  let endIndex = block.endIndex,
                  let feedback = feedbacks.first(where: { $0.baseFeedback.reference == block.id }),
                  startIndex < endIndex
            else {
                return
            }
            
            let range = NSRange(startIndex..<endIndex)
            let color = UIColor(.getHighlightColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
            
            inlineHighlights.append(HighlightedRange(id: feedback.id, range: range, color: color))
        }
        
        if shouldWipeUndo {
            undoManager.removeAllActions()
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
    
    /// Generates a `TextFeedbackDetail` instance based on the available data. Some fields might be missing
    func generateIncompleteFeedbackDetail() -> TextFeedbackDetail {
        let block = TextBlock(submissionId: submissionId,
                              text: textAtSelectedSection,
                              startIndex: selectedSection?.lowerBound,
                              endIndex: selectedSection?.upperBound)
        return TextFeedbackDetail(block: block)
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
}
