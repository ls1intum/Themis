//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Paul Schwind on 14.12.22.
//

import SwiftUI

struct EditFeedbackView: View {
    var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    let type: FeedbackType

    @Binding var showSheet: Bool
    var idForUpdate: UUID
    
    let gradingCriteria: [GradingCriterion]

    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            cvm: cvm,
            showSheet: $showSheet,
            idForUpdate: idForUpdate,
            title: "Edit Feedback",
            edit: true,
            type: type,
            gradingCriteria: gradingCriteria
        )
    }
}
