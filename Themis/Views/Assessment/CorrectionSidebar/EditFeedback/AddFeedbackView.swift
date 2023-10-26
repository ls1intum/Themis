//
//  AddFeedbackView.swift
//  Themis
//
//  Created by Paul Schwind on 14.12.22.
//

import SwiftUI
import CodeEditor
import SharedModels

struct AddFeedbackView: View {
    var assessmentResult: AssessmentResult
    weak var feedbackDelegate: (any FeedbackDelegate)?
    var incompleteFeedback: AssessmentFeedback?
    var feedbackSuggestion: (any FeedbackSuggestion)?
    
    let scope: ThemisFeedbackScope
    let gradingCriteria: [GradingCriterion]
    
    @Binding var showSheet: Bool
    
    var body: some View {
        // TODO: this structure used by AddFeedbackView and EditFeedbackView needs to be changed in the future. We can't just let EditFeedbackViewBase decide what's shown based on the parameters we pass
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            feedbackDelegate: feedbackDelegate,
            incompleteFeedback: incompleteFeedback,
            feedbackSuggestion: feedbackSuggestion,
            scope: scope,
            gradingCriteria: gradingCriteria,
            showSheet: $showSheet
        )
    }
}
