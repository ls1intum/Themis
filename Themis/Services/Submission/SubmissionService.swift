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

    /// Fetch all submissions of the exercise
    func getAllSubmissions(exerciseId: Int) async throws -> [Submission]
    
    /// Fetches all submissions of that exercise assessed by the tutor = by the user
    func getTutorSubmissions(exerciseId: Int) async throws -> [Submission]
    
    /// Fetches a random submission and locks it. This should be used to assess a random submission
    func getRandomProgrammingSubmissionForAssessment(exerciseId: Int) async throws -> ProgrammingSubmission
    
    /// Fetches a submission associated with submissionId and locks it, so no one else can assess it. This should be used to assess a specific Submission.
    func getProgrammingSubmissionForAssessment(submissionId: Int) async throws -> ProgrammingSubmission
    
    /// Fetches a result associated with participationId without locking.
    func getResultFor(participationId: Int) async throws -> Result
}

enum SubmissionServiceFactory {
    static let shared: SubmissionService = SubmissionServiceImpl()
}
