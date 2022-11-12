//
//  ArtemisAPI.swift
//  feedback2go
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

class ArtemisAPI {
    static func sendRequest<T: Decodable, R: APIRequest>(_ type: T.Type, request: R) async throws -> T {
        var request = request.request
        
        guard let token = Authentication.shared.token else {
            throw Authentication.AuthenticationError.tokenNotFound
        }
        request.setBeaererToken(token: token)
        
        return try await RESTController.shared.sendRequest(request)
    }
    
    static func sendRequest<T, R: APIRequest>(_ type: T.Type, request: R, decode: (Data) throws -> T) async throws -> T {
        var request = request.request
        
        guard let token = Authentication.shared.token else {
            throw Authentication.AuthenticationError.tokenNotFound
        }
        request.setBeaererToken(token: token)
        
        return try await RESTController.shared.sendRequest(request, decode: decode)
    }
}

protocol APIRequest {
    var request: Request { get }
}
