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
    var incompleteFeedback: AssessmentFeedback?
    weak var feedbackDelegate: (any FeedbackDelegate)?
    let scope: ThemisFeedbackScope
    @Binding var showSheet: Bool
    let gradingCriteria: [GradingCriterion]
    var feedbackSuggestion: FeedbackSuggestion?

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            feedbackDelegate: feedbackDelegate,
            showSheet: $showSheet,
            incompleteFeedback: incompleteFeedback,
            title: "Add Feedback",
            edit: false,
            scope: scope,
            gradingCriteria: gradingCriteria,
            feedbackSuggestion: feedbackSuggestion
        )
    }
}
