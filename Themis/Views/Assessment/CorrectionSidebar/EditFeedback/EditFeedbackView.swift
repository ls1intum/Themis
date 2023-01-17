//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Paul Schwind on 14.12.22.
//

import SwiftUI

struct EditFeedbackView: View {
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    let type: FeedbackType

    @Binding var showSheet: Bool
    var idForUpdate: UUID
    
    let exercise: ExerciseOfSubmission?

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: $assessmentResult,
            cvm: cvm,
            showSheet: $showSheet,
            idForUpdate: idForUpdate,
            title: "Edit feedback",
            edit: true,
            type: type,
            gradingCriteria: exercise?.gradingCriteria ?? []
        )
    }
}
