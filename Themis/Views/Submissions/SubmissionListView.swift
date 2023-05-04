//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI
import SharedModels

struct SubmissionListView: View {
    
    var submissionListVM = SubmissionListViewModel()
    let exercise: Exercise
    let submissionStatus: SubmissionStatus
    
    var body: some View {
        List {
            ForEach(submissionStatus == .open ? submissionListVM.openSubmissions : submissionListVM.submittedSubmissions, id: \.baseSubmission.id) { submission in
                NavigationLink {
                    AssessmentSubmissionLoaderView(
                        submissionID: submission.baseSubmission.id ?? -1,
                        exercise: exercise
                    )
                } label: {
                    HStack {
                        Text(verbatim: "Submission #\(submission.baseSubmission.id ?? -1)")
                            .fontWeight(.medium)
                        Spacer()
                        dateTimeline(submission: submission)
                    }
                }.padding(.trailing)
            }
        }
    }
    
    func dateTimeline(submission: Submission) -> some View {
        var dates: [(name: String, date: String?)] = []
        
        if let submissionDate = ArtemisDateHelpers
            .stringifyDate(submission.baseSubmission.submissionDate) {
            dates.append(("Submission Date", submissionDate))
        }
        if let completionDate = ArtemisDateHelpers.stringifyDate(
            submission.baseSubmission.results?.last?.completionDate), submissionStatus == .submitted {
            dates.append(("Last Assessed", completionDate))
        }
        
        return DateTimelineView(dates: dates)
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            SubmissionListView(exercise: Exercise.programming(exercise: ProgrammingExercise(id: 1)), submissionStatus: .open)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
