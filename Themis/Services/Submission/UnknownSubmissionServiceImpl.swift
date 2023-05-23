//
//  UnknownSubmissionServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 23.05.23.
//

import Foundation
import SharedModels
import Common

class UnknownSubmissionServiceImpl: SubmissionService {
    
    typealias SubmissionType = UnknownSubmission
    
    let defaultError = UserFacingError(title: "Exercise type not supported")

    func getAllSubmissions(exerciseId: Int) async throws -> [Submission] {
        throw defaultError
    }
    
    func getTutorSubmissions(exerciseId: Int) async throws -> [Submission] {
        throw defaultError
    }
    
    func getResultFor(participationId: Int) async throws -> Result {
        throw defaultError
    }
    
    func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> UnknownSubmission {
        throw defaultError
    }
    
    func getSubmissionForAssessment(submissionId: Int) async throws -> UnknownSubmission {
        throw defaultError
    }
}
