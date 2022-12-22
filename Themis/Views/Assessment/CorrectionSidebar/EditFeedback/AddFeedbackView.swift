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

    var file: Node?

    func initFeedback() {
        let lines: NSRange? = cvm.selectedSectionParsed?.0
        let columns: NSRange? = cvm.selectedSectionParsed?.1
        feedback = AssessmentFeedback(credits: 0.0, type: type, file: file, lines: lines, columns: columns)
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
