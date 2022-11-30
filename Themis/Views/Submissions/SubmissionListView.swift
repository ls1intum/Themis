//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI

struct SubmissionListView: View {
    var exerciseId: Int

    @StateObject var submissionListVM = SubmissionListViewModel()
    @ObservedObject var searchFilter = SubmissionSearchFilter()

    private func getSubmissions() -> [Submission] {
        searchFilter.determineResultsInOrder(submissions: submissionListVM.submissions)
    }

    var body: some View {
        List {
            if getSubmissions().isEmpty {
                Text("No submissions found")
            } else {
                ForEach(getSubmissions(), id: \.id) { submission in
                    NavigationLink {
                        AssessmentSubmissionLoaderView(exerciseID: exerciseId, submissionID: submission.id)
                    } label: {
                        Text("Submission \(submission.id) by \(submission.participation.student.name)")
                    }
                }
            }
        }
        .task {
            await submissionListVM.fetchTutorSubmissions(exerciseId: exerciseId)
        }
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            SubmissionListView(exerciseId: 5284)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
