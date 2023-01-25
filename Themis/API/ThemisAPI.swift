//
//  ThemisAPI.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation

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
        return try await restController.sendRequest(
            buildAuthenticatedRequest(request)
        )
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        return try await restController.sendRequest(
            buildAuthenticatedRequest(request),
            decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        try await restController.sendRequest(
            buildAuthenticatedRequest(request)
        )
    }
}
