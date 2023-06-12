//
//  TextAssessmentServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 31.05.23.
//

import Foundation
import SharedModels
import APIClient
import DesignLibrary
import Common

class TextAssessmentServiceImpl: AssessmentService {
    
    let client = APIClient()
    
    // MARK: - Cancel Assessment
    private struct CancelAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        var participationId: Int
        var submissionId: Int
        
        var method: HTTPMethod {
            .post
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/submissions/\(submissionId)/cancel-assessment"
        }
    }
    
    func cancelAssessment(participationId: Int?, submissionId: Int) async throws {
        guard let participationId else {
            throw UserFacingError.operationNotSupportedForExercise
        }
        _ = try await client.sendRequest(CancelAssessmentRequest(participationId: participationId, submissionId: submissionId)).get()
    }
    
    // MARK: - Save Assessment
    private struct SaveAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        var participationId: Int
        var resultId: Int
        var assessmentDTO: TextAssessmentResult
        
        var method: HTTPMethod {
            .put
        }
        
        var body: Encodable? {
            assessmentDTO
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/results/\(resultId)/text-assessment"
        }
    }
    
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        guard let newAssessment = newAssessment as? TextAssessmentResult,
              let resultId = newAssessment.resultId
        else {
            throw UserFacingError.operationNotSupportedForExercise
        }
        
        newAssessment.computeBlockIds()
        
        _ = try await client
            .sendRequest(SaveAssessmentRequest(participationId: participationId,
                                               resultId: resultId,
                                               assessmentDTO: newAssessment))
            .get()
    }
    
    // MARK: - Submit Assessment
    private struct SubmitAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        var participationId: Int
        var resultId: Int
        var assessmentDTO: TextAssessmentResult
        
        var method: HTTPMethod {
            .post
        }
        
        var body: Encodable? {
            assessmentDTO
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/results/\(resultId)/submit-text-assessment"
        }
    }
    
    func submitAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        guard let newAssessment = newAssessment as? TextAssessmentResult,
              let resultId = newAssessment.resultId
        else {
            throw UserFacingError.operationNotSupportedForExercise
        }
        
        newAssessment.computeBlockIds()
        
        _ = try await client
            .sendRequest(SubmitAssessmentRequest(participationId: participationId,
                                                 resultId: resultId,
                                                 assessmentDTO: newAssessment))
            .get()
    }
    
    // MARK: - Fetch Participation For Submission
    private struct GetParticipationRequest: APIRequest {
        typealias Response = Participation
        
        var participationId: Int
        var submissionId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/participations/\(participationId)/submissions/\(submissionId)/for-text-assessment"
        }
    }
    
    func fetchParticipationForSubmission(participationId: Int, submissionId: Int) async throws -> Participation {
        try await client.sendRequest(GetParticipationRequest(participationId: participationId, submissionId: submissionId)).get().0
    }
}
