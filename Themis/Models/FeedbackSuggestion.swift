//
//  FeedbackSuggestion.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation

struct NotifyRequest: Codable {
    let exercise_id: Int
    let participation_id: Int
    let server: String
}

struct FeedbackSuggestionRequest: Codable {
    let server: String
    let exercise_id: Int
    let participation_id: Int
}

struct FeedbackSuggestion: Decodable {
    let exerciseId: Int
    let participationId: Int
    let code: String
    let srcFile: String
    let fromLine: Int
    let toLine: Int
    let text: String
    let credits: Double
    
    enum DecodingKeys: String, CodingKey {
        case exercise_id
        case participation_id
        case code
        case src_file
        case from_line
        case to_line
        case text
        case credits
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        exerciseId = try values.decode(Int.self, forKey: .exercise_id)
        participationId = try values.decode(Int.self, forKey: .participation_id)
        code = try values.decode(String.self, forKey: .code)
        srcFile = try values.decode(String.self, forKey: .src_file)
        fromLine = try values.decode(Int.self, forKey: .from_line)
        toLine = try values.decode(Int.self, forKey: .to_line)
        text = try values.decode(String.self, forKey: .text)
        credits = try values.decode(Double.self, forKey: .credits)
    }
}

extension ThemisAPI {
    /// notifies Themis-ML about new feedback that should be pulled
    static func notifyAboutNewFeedback(exerciseId: Int, participationId: Int) async throws {
        let request = Request(
            method: .post,
            path: "/feedback_suggestion/notify",
            body: NotifyRequest(
                exercise_id: exerciseId,
                participation_id: participationId,
                server: RESTController.shared.baseURL.absoluteString
            )
        )
        try await restController.sendRequest(request)
    }
    
    /// gets a feedback suggestion for a submission from Themis-ML
    static func getFeedbackSuggestions(exerciseId: Int, participationId: Int) async throws -> [FeedbackSuggestion] {
        let request = Request(
            method: .post,
            path: "/feedback_suggestion",
            body: FeedbackSuggestionRequest(
                server: RESTController.shared.baseURL.absoluteString,
                exercise_id: exerciseId,
                participation_id: participationId
            )
        )
        return try await restController.sendRequest(request)
    }
    
}
