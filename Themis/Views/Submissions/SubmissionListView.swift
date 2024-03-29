//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI
import SharedModels
import Common

struct SubmissionListView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @ObservedObject var submissionListVM: SubmissionListViewModel
    
    let exercise: Exercise
    let submissionStatus: SubmissionStatus
    
    @State private var presentCancelAlert = false
    @State private var submissionBeingCancelled: Submission?
    
    private var relevantSubmissions: [Submission] {
        switch submissionStatus {
        case .open:
            submissionListVM.openSubmissions
        case .openForSecondCorrectionRound:
            submissionListVM.openSecondRoundSubmissions
        case .submitted:
            submissionListVM.submittedSubmissions
        case .submittedForSecondCorrectionRound:
            submissionListVM.submittedSecondRoundSubmissions
        }
    }
    
    private var correctionRound: CorrectionRound {
        switch submissionStatus {
        case .open, .submitted:
            return .first
        case .openForSecondCorrectionRound, .submittedForSecondCorrectionRound:
            return .second
        }
    }
    
    var body: some View {
        List {
            ForEach(relevantSubmissions.mock(if: submissionListVM.isLoading,
                                             mockElementCountRange: 1...1),
                    id: \.baseSubmission.id) { submission in
                NavigationLink {
                    AssessmentView(
                        exercise: exercise,
                        submissionId: submission.baseSubmission.id,
                        participationId: submission.baseSubmission.participation?.id,
                        resultId: submission.baseSubmission.results?.last??.id,
                        correctionRound: correctionRound
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
        .showsSkeleton(if: submissionListVM.isLoading)
        .alert("Are you sure?", isPresented: $presentCancelAlert, presenting: submissionBeingCancelled) { submission in
            Button("No", role: .cancel, action: {})
            Button("Yes, cancel", role: .destructive) {
                submissionListVM.cancel(submission, belongingTo: exercise)
            }
        } message: { _ in
            Text("This will discard the assessment and release the lock on the submission.")
        }
    }
    
    @ViewBuilder
    private func cancelButton(for submission: Submission) -> some View {
        if submissionStatus == .open || submissionStatus == .openForSecondCorrectionRound {
            Button("Cancel") {
                submissionBeingCancelled = submission
                presentCancelAlert = true
            }
            .tint(.red)
        }
    }
    
    private func dateTimeline(submission: Submission) -> some View {
        var dates: [(name: String, date: Date?)] = []
        
        if let submissionDate = (submission.baseSubmission.submissionDate) {
            dates.append(("Submission Date", submissionDate))
        }
        if let completionDate = (submission.baseSubmission.results?.last??.completionDate), submissionStatus == .submitted {
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
