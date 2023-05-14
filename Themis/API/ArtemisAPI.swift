//
//  ArtemisAPI.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

// ArtemisAPI is a stateless enum because it cannot be initialized (only static methods)
enum ArtemisAPI {
    static func sendRequest<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        try await RESTController.shared.sendRequest(request)
    }

    static func sendRequest<T>(_ type: T.Type, request: Request, decode: (Data) throws -> T) async throws -> T {
        try await RESTController.shared.sendRequest(request, decode: decode)
    }

    static func sendRequest(request: Request) async throws {
        try await RESTController.shared.sendRequest(request)
    }
}
