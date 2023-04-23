//
//  AssessmentSubmissionLoaderView.swift
//  Themis
//
//  Created by Tom Rudnick on 29.11.22.
//

import SwiftUI

struct AssessmentSubmissionLoaderView: View {
    @StateObject var avm = AssessmentViewModel(readOnly: false)
    @StateObject var cvm = CodeEditorViewModel()

    var submissionID: Int
    let exercise: Exercise

    var body: some View {
        AssessmentView(
            assessmentVM: avm,
            cvm: cvm,
            assessmentResult: avm.assessmentResult,
            exercise: exercise,
            submissionId: submissionID
        )
        .task {
            await avm.getSubmission(id: submissionID)
            if let pId = avm.submission?.participation.id {
                await cvm.initFileTree(participationId: pId)
                await cvm.loadInlineHighlight(assessmentResult: avm.assessmentResult, participationId: pId)
            }
        }
    }
}

struct AssessmentSubmissionLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentSubmissionLoaderView(submissionID: 5, exercise: Exercise())
    }
}
