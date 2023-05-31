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
    func cancelAssessment(submissionId: Int) async throws {
        throw UserFacingError(title: "Exercise type not supported")
    }
    
    // MARK: - Save Assessment
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws {
        throw UserFacingError(title: "Exercise type not supported")
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
