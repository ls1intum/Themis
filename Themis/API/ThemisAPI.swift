//
//  ThemisAPI.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation
import CodeEditor

enum ThemisAPI {
    static let restController = RESTController(baseURL: URL(string: themisServer ?? "localhost")!)
    
    private static func buildAuthenticatedRequest(_ request: Request) throws -> Request {
        var request = request
        if Authentication.shared.isBearerTokenAuthNeeded() {
            guard let token = Authentication.shared.token else {
                throw Authentication.AuthenticationError.tokenNotFound
            }
            request.headers["Authorization"] = token
        } else {
            if let cookie = HTTPCookieStorage.shared.cookies(for: RESTController.shared.baseURL)?.first {
                request.headers["Authorization"] = cookie.value
            }
        }
        return request
    }
    
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        try await restController.sendRequest(
            buildAuthenticatedRequest(request)
        )
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        try await restController.sendRequest(
            buildAuthenticatedRequest(request),
            decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        try await restController.sendRequest(
            buildAuthenticatedRequest(request)
        )
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
