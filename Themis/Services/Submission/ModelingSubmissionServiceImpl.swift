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
    
    // MARK: - Get All Submissions
    private struct GetAllSubmissionsRequest: APIRequest {
        typealias Response = [Submission]
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/modeling-submissions"
        }
    }
    
    func getAllSubmissions(exerciseId: Int) async throws -> [Submission] {
        let submissions = try await client.sendRequest(GetAllSubmissionsRequest(exerciseId: exerciseId)).get().0
        return submissions.filter({ $0.baseSubmission.results == nil }) // only get non-assessed submissions
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

    // MARK: - Get Random Modeling Submission For Assessment
    private struct GetRandomModelingSubmissionRequest: APIRequest {
        typealias Response = ModelingSubmission
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "lock", value: "true")]
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/modeling-submission-without-assessment"
        }
    }
    
    func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> ModelingSubmission {
        try await client.sendRequest(GetRandomModelingSubmissionRequest(exerciseId: exerciseId)).get().0
    }
    
    // MARK: - Get Modeling Submission For Assessment
    private struct GetModelingSubmissionRequest: APIRequest {
        typealias Response = ModelingSubmission
        
        var submissionId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/modeling-submissions/\(submissionId)"
        }
    }
    
    func getSubmissionForAssessment(submissionId: Int) async throws -> ModelingSubmission {
        try await client.sendRequest(GetModelingSubmissionRequest(submissionId: submissionId)).get().0
    }
    
    // MARK: - Get Modeling Submission
    private struct TestRequest: APIRequest {
        typealias Response = Submission
        
        var participationId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/latest-modeling-submission"
        }
    }
    
    func getSubmission(participationId: Int) async throws -> Submission {
        try await APIClient().sendRequest(TestRequest(participationId: participationId)).get().0
    }
}
