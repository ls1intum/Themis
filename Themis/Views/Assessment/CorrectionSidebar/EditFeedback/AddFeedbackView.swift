//
//  AddFeedbackView.swift
//  Themis
//
//  Created by Paul Schwind on 14.12.22.
//

import SwiftUI

struct AddFeedbackView: View {
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    let type: FeedbackType

    @Binding var showSheet: Bool

    @State var feedback = AssessmentFeedback(credits: 0.0, type: .general)

    func initFeedback() {
        feedback = AssessmentFeedback(credits: 0.0, type: type)
    }

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: $assessmentResult,
            cvm: cvm,
            feedback: $feedback,
            showSheet: $showSheet,
            title: "Add feedback",
            edit: false,
            type: type
        )
            .onAppear {
                initFeedback()
            }
    }
}
