//
//  AssessmentSubmissionLoaderView.swift
//  Themis
//
//  Created by Tom Rudnick on 29.11.22.
//

import SwiftUI

struct AssessmentSubmissionLoaderView: View {
    @StateObject var vm = AssessmentViewModel()
    var exerciseID: Int
    var submissionID: Int
    var body: some View {
        Group {
            if vm.showSubmission {
                AssessmentView(exerciseId: exerciseID).environmentObject(vm)
            } else {
                ProgressView()
            }
        }.task {
            await vm.getSubmission(id: submissionID)
        }
    }
}

struct AssessmentSubmissionLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentSubmissionLoaderView(exerciseID: 5, submissionID: 5)
    }
}
