//
//  ThemisAPI.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation
import CodeEditor

/// Handles communication with a Themis ML server
enum ThemisAPI {
    static let themisMLRestController = RESTController(baseURL: URL(string: themisServer ?? "https://ios2223cit.ase.cit.tum.de")!)
    
    private static func buildAuthenticatedRequest(_ request: Request) throws -> Request {
        var request = request
        
        if let tokenFromCookie = HTTPCookieStorage.shared.cookies(for: RESTController.shared.baseURL)?.first {
            request.setBeaererToken(token: tokenFromCookie.value)
        }
        
        return request
    }
    
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        try await themisMLRestController.sendRequest(
            buildAuthenticatedRequest(request)
        )
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        try await themisMLRestController.sendRequest(
            buildAuthenticatedRequest(request),
            decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        try await themisMLRestController.sendRequest(
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
            path: "/feedback_suggestions/notify",
            body: NotifyRequest(
                exercise_id: exerciseId,
                participation_id: participationId,
                server: removeTrailingSlash(from: RESTController.shared.baseURL.absoluteString)
            )
        )
        try await sendRequest(request: request)
    }
    
    /// gets a feedback suggestion for a submission from Themis-ML
    static func getFeedbackSuggestions(exerciseId: Int, participationId: Int) async throws -> [ProgrammingFeedbackSuggestion] {
        let request = Request(
            method: .post,
            path: "/feedback_suggestions",
            body: FeedbackSuggestionRequest(
                server: removeTrailingSlash(from: RESTController.shared.baseURL.absoluteString),
                exercise_id: exerciseId,
                participation_id: participationId
            )
        )
        return try await sendRequest([ProgrammingFeedbackSuggestion].self, request: request)
    }
    
    private static func removeTrailingSlash(from string: String) -> String {
        if string.last == "/" {
            return String(string.dropLast())
        }
        
        return string
    }
}
