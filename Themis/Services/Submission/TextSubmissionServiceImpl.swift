//
//  TextSubmissionServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 23.05.23.
//

import Foundation
import SharedModels
import APIClient
import DesignLibrary
import Common

class TextSubmissionServiceImpl: SubmissionService {
    
    typealias SubmissionType = TextSubmission
    
    let client = APIClient()
    
    // MARK: - Get All Submissions
    private struct GetAllSubmissionsRequest: APIRequest {
        typealias Response = [Submission]
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/text-submissions"
        }
    }
    
    func getAllSubmissions(exerciseId: Int) async throws -> [Submission] {
        try await client.sendRequest(GetAllSubmissionsRequest(exerciseId: exerciseId)).get().0
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
            "api/exercises/\(exerciseId)/text-submissions"
        }
    }
    
    func getTutorSubmissions(exerciseId: Int) async throws -> [Submission] {
        try await client.sendRequest(GetTutorSubmissionsRequest(exerciseId: exerciseId)).get().0
    }
    
    // MARK: - Get Random Text Submission For Assessment
    private struct GetRandomTextSubmissionRequest: APIRequest {
        typealias Response = TextSubmission
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "lock", value: "true")]
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/text-submission-without-assessment"
        }
    }
    
    func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> TextSubmission {
        try await client.sendRequest(GetRandomTextSubmissionRequest(exerciseId: exerciseId)).get().0
    }
    
    // MARK: - Get Text Submission For Assessment
    private struct GetTextSubmissionRequest: APIRequest {
        typealias Response = TextSubmission
        
        var submissionId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/text-submissions/\(submissionId)"
        }
    }
    
    func getSubmissionForAssessment(submissionId: Int) async throws -> TextSubmission {
        try await client.sendRequest(GetTextSubmissionRequest(submissionId: submissionId)).get().0
    }
    
    // MARK: - Get Result
    func getResultFor(participationId: Int) async throws -> Result {
        throw UserFacingError(title: "Exercise type not supported")
    }
}
