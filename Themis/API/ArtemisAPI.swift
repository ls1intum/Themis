//
//  ArtemisAPI.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

// ArtemisAPI is a stateless enum because it cannot be initialized (only static methods)
enum ArtemisAPI {
    // TODO: remove after bearerToken is no more
    private static func prepareBearerTokenRequest(_ request: Request) throws -> Request {
        var request = request
        guard let token = Authentication.shared.token else {
            throw Authentication.AuthenticationError.tokenNotFound
        }
        request.setBeaererToken(token: token)
        return request
    }
    // end TODO
    
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        if Authentication.shared.isBearerTokenAuthNeeded() {
            return try await RESTController.shared.sendRequest(
                prepareBearerTokenRequest(request)
            )
        }
        return try await RESTController.shared.sendRequest(request)
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        if Authentication.shared.isBearerTokenAuthNeeded() {
            return try await RESTController.shared.sendRequest(
                prepareBearerTokenRequest(request),
                decode: decode
            )
        }
        return try await RESTController.shared.sendRequest(request, decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        if Authentication.shared.isBearerTokenAuthNeeded() {
            try await RESTController.shared.sendRequest(
                prepareBearerTokenRequest(request)
            )
        }
        try await RESTController.shared.sendRequest(request)
    }
}
