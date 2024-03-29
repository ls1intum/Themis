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
    var feedbackSuggestion: FeedbackSuggestion?
    
    let scope: ThemisFeedbackScope
    let gradingCriteria: [GradingCriterion]
    
    @Binding var showSheet: Bool
    
    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            feedbackDelegate: feedbackDelegate,
            incompleteFeedback: incompleteFeedback,
            feedbackSuggestion: feedbackSuggestion,
            title: "Add Feedback",
            isEditing: false,
            scope: scope,
            gradingCriteria: gradingCriteria,
            showSheet: $showSheet
        )
    }
}
