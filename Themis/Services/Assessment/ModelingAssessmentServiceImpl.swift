//
//  ModelingAssessmentServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 22.07.23.
//

import Foundation
import SharedModels
import APIClient
import Common

struct ModelingAssessmentServiceImpl: AssessmentService {
    
    let client = APIClient()

    // MARK: - Save Assessment
    private struct SaveAssessmentRequest: APIRequest {
        typealias Response = RawResponse
        
        let submissionId: Int
        let resultId: Int
        let assessmentDTO: ModelingAssessmentResult
        
        var method: HTTPMethod {
            .put
        }
        
        var body: Encodable? {
            assessmentDTO
        }
        
        var resourceName: String {
            "api/modeling-submissions/\(submissionId)/result/\(resultId)/assessment"
        }
    }
    
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        guard let newAssessment = newAssessment as? ModelingAssessmentResult,
              let resultId = newAssessment.resultId,
              let submissionId = newAssessment.submissionId
        else {
            throw UserFacingError.operationNotSupportedForExercise
        }
        
        _ = try await client
            .sendRequest(SaveAssessmentRequest(submissionId: submissionId,
                                               resultId: resultId,
                                               assessmentDTO: newAssessment))
            .get()
    }
    
    func submitAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func fetchParticipationForSubmission(participationId: Int, submissionId: Int) async throws -> Participation {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func cancelAssessment(participationId: Int?, submissionId: Int) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
}
