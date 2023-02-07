//
//  AddFeedbackView.swift
//  Themis
//
//  Created by Paul Schwind on 14.12.22.
//

import SwiftUI
import CodeEditor

struct AddFeedbackView: View {
    var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    let type: FeedbackType
    @Binding var showSheet: Bool
    var file: Node?
    let gradingCriteria: [GradingCriterion]
    var feedbackSuggestion: FeedbackSuggestion?

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            cvm: cvm,
            showSheet: $showSheet,
            title: "Add Feedback",
            edit: false,
            type: type,
            file: file,
            gradingCriteria: gradingCriteria,
            feedbackSuggestion: feedbackSuggestion
        )
    }
}
