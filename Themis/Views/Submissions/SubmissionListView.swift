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
    let maxPoints: Double

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
                            exerciseTitle: exerciseTitle,
                            maxPoints: maxPoints
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
            SubmissionListView(exerciseId: 5284, exerciseTitle: "Example Exercise", maxPoints: 100)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
