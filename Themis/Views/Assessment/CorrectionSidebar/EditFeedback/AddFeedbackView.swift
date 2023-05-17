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
    @ObservedObject var codeEditorVM: CodeEditorViewModel
    let scope: ThemisFeedbackScope
    @Binding var showSheet: Bool
    let gradingCriteria: [GradingCriterion]
    var feedbackSuggestion: FeedbackSuggestion?

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            cvm: codeEditorVM,
            showSheet: $showSheet,
            title: "Add Feedback",
            edit: false,
            scope: scope,
            gradingCriteria: gradingCriteria,
            feedbackSuggestion: feedbackSuggestion
        )
    }
}
