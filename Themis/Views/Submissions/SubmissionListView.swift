//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI
import SharedModels

struct SubmissionListView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @ObservedObject var submissionListVM: SubmissionListViewModel
    
    let exercise: Exercise
    let submissionStatus: SubmissionStatus
    
    var body: some View {
        List {
            ForEach(submissionStatus == .open ? submissionListVM.openSubmissions : submissionListVM.submittedSubmissions, id: \.baseSubmission.id) { submission in
                NavigationLink {
                    AssessmentView(
                        exercise: exercise,
                        submissionId: submission.baseSubmission.id,
                        participationId: submission.baseSubmission.participation?.id,
                        resultId: submission.baseSubmission.results?.last?.id
                    )
                    .environmentObject(courseVM)
                } label: {
                    HStack {
                        Text(verbatim: "Submission #\(submission.baseSubmission.id ?? -1)")
                            .fontWeight(.medium)
                        Spacer()
                        dateTimeline(submission: submission)
                    }
                    .swipeActions { cancelButton(for: submission) }
                }.padding(.trailing)
            }
        }
    }
    
    @ViewBuilder
    private func cancelButton(for submission: Submission) -> some View {
        if submissionStatus == .open {
            Button("Cancel") {
                submissionListVM.cancel(submission, belongingTo: exercise)
            }
            .tint(.red)
        }
    }
    
    private func dateTimeline(submission: Submission) -> some View {
        var dates: [(name: String, date: Date?)] = []
        
        if let submissionDate = (submission.baseSubmission.submissionDate) {
            dates.append(("Submission Date", submissionDate))
        }
        if let completionDate = (submission.baseSubmission.results?.last?.completionDate), submissionStatus == .submitted {
            dates.append(("Last Assessed", completionDate))
        }
        
        return DateTimelineView(dates: dates)
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            SubmissionListView(submissionListVM: SubmissionListViewModel(),
                               exercise: Exercise.programming(exercise: ProgrammingExercise(id: 1)),
                               submissionStatus: .open)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
