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
import Common

struct ProgrammingAssessmentServiceImpl: AssessmentService {
    
    let client = APIClient()
    
    // MARK: - Cancel Assessment
    private struct CancelAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        let submissionId: Int
        
        var method: HTTPMethod {
            .put
        }
        
        var resourceName: String {
            "api/programming-submissions/\(submissionId)/cancel-assessment"
        }
    }
    
    func cancelAssessment(participationId: Int?, submissionId: Int) async throws {
        _ = try await client.sendRequest(CancelAssessmentRequest(submissionId: submissionId)).get()
    }
    
    // MARK: - Save Assessment
    private struct SaveAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        let participationId: Int
        let newAssessment: AssessmentResult
        let submit: Bool
        
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
    
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        _ = try await client
            .sendRequest(SaveAssessmentRequest(participationId: participationId,
                                               newAssessment: newAssessment,
                                               submit: false))
            .get()
    }
    
    // MARK: - Submit Assessment
    func submitAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        _ = try await client
            .sendRequest(SaveAssessmentRequest(participationId: participationId,
                                               newAssessment: newAssessment,
                                               submit: true))
            .get()
    }
    
    // MARK: - Fetch Participation For Submission
    func fetchParticipationForSubmission(submissionId: Int) async throws -> Participation {
        throw UserFacingError.operationNotSupportedForExercise
    }
}
