//
//  UnknownAssessmentServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 31.05.23.
//

import Foundation
import SharedModels
import Common

class UnknownAssessmentServiceImpl: AssessmentService {
    
    // MARK: - Cancel Assessment
    func cancelAssessment(submissionId: Int) async throws {
        throw UserFacingError(title: "Exercise type not supported")
    }
    
    // MARK: - Save Assessment
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws {
        throw UserFacingError(title: "Exercise type not supported")
    }
    
    // MARK: - Fetch Participation For Submission
    func fetchParticipationForSubmission(participationId: Int, submissionId: Int) async throws -> Participation {
        throw UserFacingError(title: "Exercise type not supported")
    }
}
