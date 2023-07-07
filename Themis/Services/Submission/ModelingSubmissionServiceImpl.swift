//
//  ModelingSubmissionServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import Foundation
import APIClient
import SharedModels
import DesignLibrary
import Common

class ModelingSubmissionServiceImpl: SubmissionService {
    typealias SubmissionType = ModelingSubmission
    
    let client = APIClient()
    
    func getAllSubmissions(exerciseId: Int) async throws -> [SharedModels.Submission] {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    // MARK: - Get Tutor Submissions
    private struct GetTutorSubmissionsRequest: APIRequest {
        typealias Response = [Submission]
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "assessedByTutor", value: "true")]
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/modeling-submissions"
        }
    }
    
    func getTutorSubmissions(exerciseId: Int) async throws -> [Submission] {
        try await client.sendRequest(GetTutorSubmissionsRequest(exerciseId: exerciseId)).get().0
    }

    func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> SharedModels.ModelingSubmission {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func getSubmissionForAssessment(submissionId: Int) async throws -> SharedModels.ModelingSubmission {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func getResultFor(participationId: Int) async throws -> SharedModels.Result {
        throw UserFacingError.operationNotSupportedForExercise
    }
}
