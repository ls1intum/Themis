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
    private struct GetAllSubmissionsRequest: APIRequest {
        typealias Response = [Submission]
        
        var exerciseId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/file-upload-submissions"
        }
    }
    
    func getAllSubmissions(exerciseId: Int) async throws -> [SharedModels.Submission] {
        let submissions = try await client.sendRequest(GetAllSubmissionsRequest(exerciseId: exerciseId)).get().0
        return submissions.filter({ $0.baseSubmission.results == nil }) // only get non-assessed submissions
    }
    
    // MARK: - Get Tutor Submissions
    private struct GetTutorSubmissionsRequest: APIRequest {
        typealias Response = [Submission]
        
        var exerciseId: Int
        var correctionRound: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [
                URLQueryItem(name: "assessedByTutor", value: "true"),
                URLQueryItem(name: "correction-round", value: "\(correctionRound)")
            ]
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/file-upload-submissions"
        }
    }
    
    func getTutorSubmissions(exerciseId: Int, correctionRound: CorrectionRound) async throws -> [Submission] {
        try await client.sendRequest(GetTutorSubmissionsRequest(exerciseId: exerciseId,
                                                                correctionRound: correctionRound.rawValue))
            .get().0
    }
    
    // MARK: - Get Random File Upload Submission For Assessment
    private struct GetRandomFileUploadSubmissionRequest: APIRequest {
        typealias Response = FileUploadSubmission
        
        var exerciseId: Int
        var correctionRound: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [
                URLQueryItem(name: "lock", value: "true"),
                URLQueryItem(name: "correction-round", value: "\(correctionRound)")
            ]
        }
        
        var resourceName: String {
            "api/exercises/\(exerciseId)/file-upload-submission-without-assessment"
        }
    }
    
    func getRandomSubmissionForAssessment(exerciseId: Int, correctionRound: CorrectionRound) async throws -> SubmissionType {
        try await client.sendRequest(GetRandomFileUploadSubmissionRequest(exerciseId: exerciseId,
                                                                          correctionRound: correctionRound.rawValue))
            .get().0
    }
    
    // MARK: - Get File Upload Submission For Assessment
    private struct GetFileUploadSubmissionRequest: APIRequest {
        typealias Response = FileUploadSubmission
        
        var submissionId: Int
        var correctionRound: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "correction-round", value: "\(correctionRound)")]
        }
        
        var resourceName: String {
            "api/file-upload-submissions/\(submissionId)"
        }
    }
    
    func getSubmissionForAssessment(submissionId: Int, correctionRound: CorrectionRound) async throws -> SubmissionType {
        try await client.sendRequest(GetFileUploadSubmissionRequest(submissionId: submissionId,
                                                                    correctionRound: correctionRound.rawValue))
            .get().0
    }
    
    // MARK: - Get File Upload Submission
    private struct GetFileUploadSubmission: APIRequest {
        typealias Response = Submission
        
        var participationId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/file-upload-editor"
        }
    }
    
    func getSubmission(participationId: Int) async throws -> Submission {
        try await APIClient().sendRequest(GetFileUploadSubmission(participationId: participationId)).get().0
    }
}
