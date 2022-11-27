//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI

struct SubmissionListView: View {

    @StateObject var submissionListVM = SubmissionListViewModel()

    var exerciseId: Int

    var body: some View {
        NavigationStack {
            NavigationLink(destination: AssessmentView(exerciseId: 5284)) {
                Text("Assess random submission")
            }
            List {
                ForEach(submissionListVM.submissions, id: \.id) { submission in
                    NavigationLink {
                    } label: {
                        Text("Submission \(submission.id)")
                        // Text("Submission \(submission.id) by \(submission.participation.student.name)")
                    }
                }
            }
            .overlay(Group {
                if submissionListVM.submissions.isEmpty {
                    Text("No submissions")
                }
            })
        }
        .navigationTitle("Your Submissions")
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
