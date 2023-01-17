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
    
    var file: Node?
    
    let exercise: ExerciseOfSubmission?

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: $assessmentResult,
            cvm: cvm,
            showSheet: $showSheet,
            title: "Add feedback",
            edit: false,
            type: type,
            file: file,
            gradingCriteria: exercise?.gradingCriteria ?? []
        )
    }
}
