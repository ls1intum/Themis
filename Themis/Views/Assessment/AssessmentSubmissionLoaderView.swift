//
//  AssessmentSubmissionLoaderView.swift
//  Themis
//
//  Created by Tom Rudnick on 29.11.22.
//

import SwiftUI

struct AssessmentSubmissionLoaderView: View {
    @StateObject var avm = AssessmentViewModel(readOnly: false)

    var submissionID: Int
    let exercise: Exercise

    var body: some View {
        AssessmentView(
            vm: avm,
            ar: avm.assessmentResult,
            exercise: exercise,
            submissionId: submissionID
        )
    }
}

struct AssessmentSubmissionLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentSubmissionLoaderView(submissionID: 5, exercise: Exercise())
    }
}
