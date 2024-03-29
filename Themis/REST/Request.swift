//
//  Request.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation
import APIClient

struct Request {
    var method: HTTPMethod
    var path: String
    var params: [URLQueryItem]
    var headers: [String: String] = [:]
    var body: Encodable?

    init(method: HTTPMethod, path: String = "/", params: [URLQueryItem] = [], headers: [String: String]? = nil, body: Encodable? = nil) {
        self.method = method
        self.path = path
        self.params = params
        self.headers = headers ?? defaultHeader()
        self.body = body
    }

    private func defaultHeader() -> [String: String] {
        var dict: [String: String] = [:]
        dict["Content-Type"] = "application/json"
        dict["User-Agent"] = "iOS-App"
        return dict
    }

    public mutating func addHeaderField(field: String, value: String) {
        self.headers[field] = value
    }

    public mutating func setBeaererToken(token: String) {
        addHeaderField(field: "Authorization", value: "Bearer \(token)")
    }
}
