//
//  AssessmentServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import APIClient
import DesignLibrary

class AssessmentServiceImpl: AssessmentService {
    
    let client = APIClient()
    
    // MARK: - Cancel Assessment
    struct CancelAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        var submissionId: Int
        
        var method: HTTPMethod {
            .put
        }
        
        var resourceName: String {
            "api/programming-submissions/\(submissionId)/cancel-assessment"
        }
    }
    
    func cancelAssessment(submissionId: Int) async throws {
        _ = try await client.sendRequest(CancelAssessmentRequest(submissionId: submissionId)).get()
    }
    
    // MARK: - Save Assessment
    struct SaveAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        var participationId: Int
        var newAssessment: AssessmentResult
        var submit: Bool
        
        var method: HTTPMethod {
            .put
        }
        
        var body: Encodable? {
            newAssessment
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "submit", value: String(submit))]
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/manual-results"
        }
    }
    
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws {
        _ = try await client
            .sendRequest(SaveAssessmentRequest(participationId: participationId,
                                               newAssessment: newAssessment,
                                               submit: submit))
            .get()
    }
}
