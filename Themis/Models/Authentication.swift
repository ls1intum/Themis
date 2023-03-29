//
//  AuthenticationController.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation
import KeychainAccess

private struct AuthBody: Encodable {
    let username: String
    let password: String
    let rememberMe: Bool
}

class Authentication: NSObject {

    static var shared = Authentication()
    
    @objc dynamic var authenticated = false
    
    override private init() {}
    
    /// This Method allows the user to Authenticate. If it doesnt throw an Error the token will be set as a cookie
    /// If the rememberMe flag is set the token will be valid for 30 Days (if not 30 minutes)
    func auth(username: String, password: String, rememberMe: Bool = false) async throws {
        let body = AuthBody(username: username, password: password, rememberMe: rememberMe)
        let request = Request(method: .post, path: "/api/authenticate", body: body)
        
        try await RESTController.shared.sendRequest(request)
        checkAuth()
    }
    
    func logOut() async throws {
        let request = Request(method: .post, path: "/api/logout")
        try await RESTController.shared.sendRequest(request)
        checkAuth()
    }

    func checkAuth() {
        let cookie = HTTPCookieStorage.shared.cookies(for: RESTController.shared.baseURL)?.first { cookie in
            guard let exp = cookie.expiresDate else {
                return false
            }
            return cookie.name == "jwt" && Date() < exp
        }
        self.authenticated = cookie != nil
    }
}
