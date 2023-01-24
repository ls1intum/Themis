//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI

struct SubmissionListView: View {

    var submissionListVM = SubmissionListViewModel()
    var exerciseId: Int
    let exerciseTitle: String

    var body: some View {
        List {
            if submissionListVM.submissions.isEmpty {
                Text("No submissions")
            } else {
                ForEach(submissionListVM.submissions, id: \.id) { submission in
                    NavigationLink {
                        AssessmentSubmissionLoaderView(
                            exerciseID: exerciseId,
                            submissionID: submission.id,
                            exerciseTitle: exerciseTitle
                        )
                    } label: {
                        Text("Submission \(submission.id)")
                    }
                }
            }
        }
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionListView(exerciseId: 5284, exerciseTitle: "Example Exercise")
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
