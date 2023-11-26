//
//  AthenaService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 14.08.23.
//

import Foundation
import SharedModels
import APIClient
import CodeEditor

/// A service that communicates with the Athena-related endpoints of Artemis to handle automatic feedback suggestions
/// For more info about Athena: https://github.com/ls1intum/Athena
struct AthenaService {
    
    let client = APIClient()
    
    private struct GetFeedbackSuggestionsRequest<ResponseType: Decodable>: APIRequest {
        typealias Response = [ResponseType]
        
        let exerciseType: String
        let exerciseId: Int
        let submissionId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/athena/\(exerciseType)-exercises/\(exerciseId)/submissions/\(submissionId)/feedback-suggestions"
        }
    }
    
    // MARK: - Get Text Feedback Suggestions
    func getTextFeedbackSuggestions(exerciseId: Int, submissionId: Int) async throws -> [TextFeedbackSuggestion] {
        try await client
            .sendRequest(GetFeedbackSuggestionsRequest<TextFeedbackSuggestion>(exerciseType: TextExercise.type,
                                                                               exerciseId: exerciseId,
                                                                               submissionId: submissionId))
            .get().0
    }
    
    // MARK: - Get Programming Feedback Suggestions
    func getProgrammingFeedbackSuggestions(exerciseId: Int, submissionId: Int) async throws -> [ProgrammingFeedbackSuggestion] {
        try await client
            .sendRequest(GetFeedbackSuggestionsRequest<ProgrammingFeedbackSuggestion>(exerciseType: ProgrammingExercise.type,
                                                                                      exerciseId: exerciseId,
                                                                                      submissionId: submissionId))
            .get().0
    }
}
