//
//  ArtemisAPI.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

class ArtemisAPI {
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        if bearerTokenAuth {
            var request = request
            guard let token = Authentication.shared.token else {
                throw Authentication.AuthenticationError.tokenNotFound
            }
            request.setBeaererToken(token: token)
            return try await RESTController.shared.sendRequest(request)
        }
        return try await RESTController.shared.sendRequest(request)
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        if bearerTokenAuth {
            var request = request
            guard let token = Authentication.shared.token else {
                throw Authentication.AuthenticationError.tokenNotFound
            }
            request.setBeaererToken(token: token)
            return try await RESTController.shared.sendRequest(request, decode: decode)
        }
        return try await RESTController.shared.sendRequest(request, decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        if bearerTokenAuth {
            var request = request
            guard let token = Authentication.shared.token else {
                throw Authentication.AuthenticationError.tokenNotFound
            }
            request.setBeaererToken(token: token)
            try await RESTController.shared.sendRequest(request)
        }
        try await RESTController.shared.sendRequest(request)
    }
}
