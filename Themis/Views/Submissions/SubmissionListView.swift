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
    let submissionStatus: SubmissionStatus
    
    var body: some View {
        List {
            ForEach(submissionStatus == .open ? submissionListVM.openSubmissions : submissionListVM.submittedSubmissions, id: \.id) { submission in
                NavigationLink {
                    AssessmentSubmissionLoaderView(
                        submissionID: submission.id,
                        exercise: exercise
                    )
                } label: {
                    HStack {
                        Text(verbatim: "Submission #\(submission.id)")
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
            .parseDetailedDateToNormalDate(submission.submissionDate) {
            dates.append(("Submission Date", submissionDate))
        }
        if let completionDate = ArtemisDateHelpers.parseDetailedDateToNormalDate(
            submission.results.last?.completionDate), submissionStatus == .submitted {
            dates.append(("Last Assessed", completionDate))
        }
        
        return DateTimelineView(dates: dates)
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            SubmissionListView(exercise: Exercise(), submissionStatus: .open)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
