//
//  FeedbackDelegate.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 29.05.23.
//

import Foundation
import CodeEditor

/// A protocol intended to be used by objects interested in feedback-related events
protocol FeedbackDelegate: ObservableObject, AnyObject {
    func onFeedbackCreation(_ feedback: AssessmentFeedback)
    func onFeedbackUpdate(_ feedback: AssessmentFeedback)
    func onFeedbackDeletion(_ feedback: AssessmentFeedback)
    func onFeedbackSuggestionSelection(_ suggestion: any FeedbackSuggestion, _ feedback: AssessmentFeedback)
    func onFeedbackSuggestionDiscard(_ suggestion: any FeedbackSuggestion)
    func onFeedbackCellTap(_ feedback: AssessmentFeedback, participationId: Int?, templateParticipationId: Int?)
}

// Make conformance optional by providing empty implementations
extension FeedbackDelegate {
    func onFeedbackCreation(_ feedback: AssessmentFeedback) {}
    
    func onFeedbackUpdate(_ feedback: AssessmentFeedback) {}
    
    func onFeedbackDeletion(_ feedback: AssessmentFeedback) {}
    
    func onFeedbackSuggestionSelection(_ suggestion: any FeedbackSuggestion, _ feedback: AssessmentFeedback) {}
    
    func onFeedbackSuggestionDiscard(_ suggestion: any FeedbackSuggestion) {}
    
    func onFeedbackCellTap(_ feedback: AssessmentFeedback, participationId: Int?, templateParticipationId: Int?) {}
}
