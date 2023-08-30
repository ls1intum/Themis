//
//  SubmissionListViewModel.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import Common
import Foundation
import SharedModels

class SubmissionListViewModel: ObservableObject {
    @Published var submissions: [Submission] = []
    @Published var error: Error?
    
    var submittedSubmissions: [Submission] {
        submissions.filter { $0.baseSubmission.isAssessed }
    }
    
    var openSubmissions: [Submission] {
        submissions.filter { !$0.baseSubmission.isAssessed }
    }
    
    @MainActor
    func fetchTutorSubmissions(for exercise: Exercise) async {
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            self.submissions = try await submissionService.getTutorSubmissions(exerciseId: exercise.id)
        } catch let error {
            self.error = error
            log.error(String(describing: error))
        }
    }
}

 enum SubmissionStatus {
    case open
    case submitted
 }
