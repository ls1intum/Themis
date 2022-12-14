//
//  RESTController.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

class RESTController {
    static var shared: RESTController!

    var baseURL: URL

    private var jsonEncoder = JSONEncoder()
    private var jsonDecoder = JSONDecoder()

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func sendRequest(_ request: Request) async throws {
        let request = try makeURLRequest(request)
        let (_, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
    }

    func sendRequest<T: Decodable>(_ request: Request) async throws -> T {
        try await sendRequest(request, decode: { data in
            try jsonDecoder.decode(T.self, from: data)
        })
    }

    func sendRequest<T>(_ request: Request, decode: (Data) throws -> T) async throws -> T {
        let request = try makeURLRequest(request)
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)

        // check for empty response
        if data.isEmpty {
            throw RESTError.empty
        }

        return try decode(data)
    }

    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 400:
            throw RESTError.badRequest
        case 401:
            Authentication.shared.authenticated = false
            throw RESTError.unauthorized
        case 403:
            throw RESTError.forbidden
        case 404:
            throw RESTError.notFound
        case 405:
            throw RESTError.methodNotAllowed
        case 500..<600:
            throw RESTError.server
        default:
            throw RESTError.different
        }
    }

    private func makeURLRequest(_ request: Request) throws -> URLRequest {
        let url = makeURL(with: request.path, params: request.params)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        if let body = request.body {
            let encodedBody = try jsonEncoder.encode(body)
            urlRequest.httpBody = encodedBody
        }
        return urlRequest
    }

    private func makeURL(with path: String, params: [URLQueryItem]) -> URL {
        var newURL = baseURL
        newURL.append(path: path)
        newURL.append(queryItems: params)
        return newURL
    }
}
