//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI

struct SubmissionListView: View {

    var submissionListVM = SubmissionListViewModel()
    let exercise: Exercise

    var body: some View {
        List {
            if submissionListVM.submissions.isEmpty {
                Text("No submissions")
            } else {
                ForEach(submissionListVM.submissions, id: \.id) { submission in
                    NavigationLink {
                        AssessmentSubmissionLoaderView(
                            submissionID: submission.id,
                            exercise: exercise
                        )
                    } label: {
                        HStack {
                            Text(verbatim: "Submission \(submission.id)")
                            Spacer()
                            VStack {
                                let submissionDate = ArtemisDateHelpers.getReadableDateStringDetailed(submission.submissionDate) ?? "Unavailable"
                                let completionDate = ArtemisDateHelpers.getReadableDateStringDetailed(
                                    submission.results.last?.completionDate) ?? "A few seconds ago"
                                
                                Text("Submission date: \(submissionDate)")
                                Text("Last assessed: \(completionDate)")
                            }
                        }.padding(.trailing)
                    }
                }
            }
        }
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            SubmissionListView(exercise: Exercise())
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
