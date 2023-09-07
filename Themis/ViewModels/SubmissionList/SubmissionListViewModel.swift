//
//  SubmissionListViewModel.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import Common
import SwiftUI
import SharedModels

class SubmissionListViewModel: ObservableObject {
    @Published var submissions: [Submission] = []
    @Published var error: Error?
    
    var submittedSubmissions: [Submission] {
        submissions.filter { $0.baseSubmission.results?.last?.completionDate != nil }
    }
    
    var openSubmissions: [Submission] {
        submissions.filter { $0.baseSubmission.results?.last?.completionDate == nil }
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
    
    @MainActor
    func cancel(_ submission: Submission, belongingTo exercise: Exercise) {
        guard let participationId = submission.getParticipation()?.id,
              let submissionId = submission.baseSubmission.id else {
            log.error("Could not cancel assessment due to missing participation or submission ID")
            return
        }
        
        Task {
            do {
                let assessmentService = AssessmentServiceFactory.service(for: exercise)
                try await assessmentService.cancelAssessment(participationId: participationId, submissionId: submissionId)
                withAnimation {
                    self.submissions.removeAll(where: { $0.baseSubmission.id == submissionId })
                }
            } catch let error {
                log.error(String(describing: error))
            }
        }
    }
}

 enum SubmissionStatus {
    case open
    case submitted
 }
