//
//  ArtemisAPI.swift
//  feedback2go
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

class ArtemisAPI {
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        var request = request

        guard let token = Authentication.shared.token else {
            throw Authentication.AuthenticationError.tokenNotFound
        }
        request.setBeaererToken(token: token)

        return try await RESTController.shared.sendRequest(request)
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        var request = request

        guard let token = Authentication.shared.token else {
            throw Authentication.AuthenticationError.tokenNotFound
        }
        request.setBeaererToken(token: token)

        return try await RESTController.shared.sendRequest(request, decode: decode)
    }
}
