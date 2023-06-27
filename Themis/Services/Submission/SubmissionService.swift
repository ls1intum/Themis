//
//  SubmissionService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import Common

protocol SubmissionService {
    associatedtype SubmissionType: BaseSubmission
    
    /// Fetch all submissions of the exercise
    func getAllSubmissions(exerciseId: Int) async throws -> [Submission]
    
    /// Fetches all submissions of that exercise previously assessed by the tutor (user)
    func getTutorSubmissions(exerciseId: Int) async throws -> [Submission]
    
    /// Fetches a random submission and locks it. This should be used to assess a random submission
    func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> SubmissionType
    
    /// Fetches a submission associated with submissionId and locks it, so no one else can assess it. This should be used to assess a specific Submission.
    func getSubmissionForAssessment(submissionId: Int) async throws -> SubmissionType
    
    /// Fetches a result associated with participationId without locking.
    func getResultFor(participationId: Int) async throws -> Result
}

enum SubmissionServiceFactory {
    static func service(for exercise: Exercise) -> any SubmissionService {
        switch exercise {
        case .programming(exercise: _):
            return ProgrammingSubmissionServiceImpl()
        case .text(exercise: _):
            return TextSubmissionServiceImpl()
        default:
            return UnknownSubmissionServiceImpl()
        }
    }
}
