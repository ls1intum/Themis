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
    @Published var secondCorrectionRoundSubmissions: [Submission] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    var submittedSubmissions: [Submission] {
        submissions.filter { $0.baseSubmission.results?.last??.completionDate != nil }
    }
    
    var submittedSecondRoundSubmissions: [Submission] {
        secondCorrectionRoundSubmissions.filter { $0.baseSubmission.results?.last??.completionDate != nil }
    }
    
    var openSubmissions: [Submission] {
        submissions.filter { !$0.baseSubmission.isAssessed }
    }
    
    var openSecondRoundSubmissions: [Submission] {
        secondCorrectionRoundSubmissions.filter { !$0.baseSubmission.isAssessed }
    }
    
    private var isLoadedOnce = false
    
    @MainActor
    func fetchTutorSubmissions(for exercise: Exercise, correctionRound round: CorrectionRound = .first) async {
        isLoading = isLoadedOnce ? isLoading : true
        defer {
            isLoading = false
            isLoadedOnce = true
        }
        
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            
            switch round {
            case .first:
                self.submissions = try await submissionService.getTutorSubmissions(exerciseId: exercise.id,
                                                                                   correctionRound: round.rawValue)
            case .second:
                self.secondCorrectionRoundSubmissions = try await submissionService.getTutorSubmissions(exerciseId: exercise.id, 
                                                                                                        correctionRound: round.rawValue)
            }
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
                    self.secondCorrectionRoundSubmissions.removeAll(where: { $0.baseSubmission.id == submissionId })
                }
            } catch let error {
                log.error(String(describing: error))
            }
        }
    }
}

enum SubmissionStatus {
    case open
    case openForSecondCorrectionRound
    case submitted
    case submittedForSecondCorrectionRound
}

enum CorrectionRound: Int {
    case first = 0
    case second = 1
}
