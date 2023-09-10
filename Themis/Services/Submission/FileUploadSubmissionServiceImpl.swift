//
//  FileUploadSubmissionServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 10.09.23.
//

import Foundation
import APIClient
import SharedModels
import Common

class FileUploadSubmissionServiceImpl: SubmissionService {
    typealias SubmissionType = FileUploadSubmission
    
    let client = APIClient()
    
    // MARK: - Get All Submissions
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
            "api/exercises/\(exerciseId)/file-upload-submissions"
        }
    }
    
    func getTutorSubmissions(exerciseId: Int) async throws -> [Submission] {
        try await client.sendRequest(GetTutorSubmissionsRequest(exerciseId: exerciseId)).get().0
    }
    
    // MARK: - Get Random File Upload Submission For Assessment
    private struct GetRandomFileUploadSubmissionRequest: APIRequest {
        typealias Response = FileUploadSubmission
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "lock", value: "true")]
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/file-upload-submission-without-assessment"
        }
    }
    
    func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> SubmissionType {
        try await client.sendRequest(GetRandomFileUploadSubmissionRequest(exerciseId: exerciseId)).get().0
    }
    
    // MARK: - Get File Upload Submission For Assessment
    func getSubmissionForAssessment(submissionId: Int) async throws -> SubmissionType {
        throw UserFacingError.operationNotSupportedForExercise
    }
}
