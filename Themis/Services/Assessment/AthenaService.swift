//
//  AthenaService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 14.08.23.
//

import Foundation
import SharedModels
import APIClient

/// A service that communicates with the Athena-related endpoints of Artemis to handle automatic feedback suggestions
/// For more info about Athena: https://github.com/ls1intum/Athena
struct AthenaService {
    
    let client = APIClient()
    
    // MARK: - Get Feedback Suggestions
    private struct GetFeedbackSuggestionsRequest: APIRequest {
        typealias Response = [TextBlockRef]
        
        let exerciseId: Int
        let submissionId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/athena/exercises/\(exerciseId)/submissions/\(submissionId)/feedback-suggestions"
        }
    }
    
    func getFeedbackSuggestions(exerciseId: Int, submissionId: Int) async throws -> [TextBlockRef] {
        try await client.sendRequest(GetFeedbackSuggestionsRequest(exerciseId: exerciseId, submissionId: submissionId)).get().0
    }
}
