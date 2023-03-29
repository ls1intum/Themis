//
//  ThemisAPI.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation
import CodeEditor

enum ThemisAPI {
    static let restController = RESTController(baseURL: URL(string: themisServer ?? "https://ios2223cit.ase.cit.tum.de")!)
    
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        try await restController.sendRequest(request)
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        try await restController.sendRequest(request, decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        try await restController.sendRequest(request)
    }
}

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

extension ThemisAPI {
    /// notifies Themis-ML about new feedback that should be pulled
    static func notifyAboutNewFeedback(exerciseId: Int, participationId: Int) async throws {
        let request = Request(
            method: .post,
            path: "/feedback_suggestions/notify",
            body: NotifyRequest(
                exercise_id: exerciseId,
                participation_id: participationId,
                server: RESTController.shared.baseURL.absoluteString
            )
        )
        try await sendRequest(request: request)
    }
    
    /// gets a feedback suggestion for a submission from Themis-ML
    static func getFeedbackSuggestions(exerciseId: Int, participationId: Int) async throws -> [FeedbackSuggestion] {
        let request = Request(
            method: .post,
            path: "/feedback_suggestions",
            body: FeedbackSuggestionRequest(
                server: RESTController.shared.baseURL.absoluteString,
                exercise_id: exerciseId,
                participation_id: participationId
            )
        )
        return try await sendRequest([FeedbackSuggestion].self, request: request)
    }
}
