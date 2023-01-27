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

    var exerciseID: Int
    var submissionID: Int
    let exerciseTitle: String
    let maxPoints: Double

    var body: some View {
        AssessmentView(
            vm: avm,
            cvm: cvm,
            ar: avm.assessmentResult,
            exerciseId: exerciseID,
            exerciseTitle: exerciseTitle,
            maxPoints: maxPoints
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
        AssessmentSubmissionLoaderView(exerciseID: 5, submissionID: 5, exerciseTitle: "Example Exercise", maxPoints: 100)
    }
}
