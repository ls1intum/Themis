//
//  FileUploadAssessmentServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.09.23.
//

import Foundation
import SharedModels
import APIClient
import Common

struct FileUploadAssessmentServiceImpl: AssessmentService {
    
    let client = APIClient()

    // MARK: - Cancel Assessment
    private struct CancelAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        let submissionId: Int
        
        var method: HTTPMethod {
            .put
        }
        
        var resourceName: String {
            "api/file-upload-submissions/\(submissionId)/cancel-assessment"
        }
    }
    
    func cancelAssessment(participationId: Int?, submissionId: Int) async throws {
        _ = try await client.sendRequest(CancelAssessmentRequest(submissionId: submissionId)).get()
    }
    
    // MARK: - Save Assessment
    private struct SaveAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        let submissionId: Int
        let assessmentDTO: AssessmentResult
        
        var method: HTTPMethod {
            .put
        }
        
        var body: Encodable? {
            assessmentDTO
        }
        
        var resourceName: String {
            "api/file-upload-submissions/\(submissionId)/feedback"
        }
    }

    func saveAssessment(submissionId: Int, newAssessment: AssessmentResult) async throws {
        _ = try await client.sendRequest(SaveAssessmentRequest(submissionId: submissionId,
                                                               assessmentDTO: newAssessment))
        .get()
    }
    
    // MARK: - Save Assessment
    private struct SubmitAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        let submissionId: Int
        let assessmentDTO: AssessmentResult
        
        var method: HTTPMethod {
            .put
        }
        
        var body: Encodable? {
            assessmentDTO
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "submit", value: "true")]
        }
        
        var resourceName: String {
            "api/file-upload-submissions/\(submissionId)/feedback"
        }
    }
    
    func submitAssessment(submissionId: Int, newAssessment: AssessmentResult) async throws {
        _ = try await client.sendRequest(SubmitAssessmentRequest(submissionId: submissionId,
                                                                 assessmentDTO: newAssessment))
        .get()
    }
}
