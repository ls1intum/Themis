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

    static var shared: Authentication!

    // TODO: remove after bearer token auth is no more
    enum AuthenticationError: Error {
        case tokenNotFound
    }
    @objc dynamic var token: String?
    let keychain: Keychain
    
    private func getArtemisMajorVersion() async throws -> Int? {
        let request = URLRequest(url: RESTController.shared.baseURL)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let version = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Content-Version") as? String else {
            return nil
        }
        guard let major = version.split(separator: ".").first else {
            return nil
        }
        return Int(major)
    }
    
    private var bearerTokenAuthNeeded = false
    private func fetchNeedsBearerTokenAuth() async {
        if let mVersion = try? await getArtemisMajorVersion() {
            bearerTokenAuthNeeded = mVersion < 6
        } else {
            print("Fetching bearer token auth info did not work! Trying again...")
            try? await Task.sleep(until: .now + .seconds(5), clock: .continuous)
            await fetchNeedsBearerTokenAuth()
        }
    }
    
    func isBearerTokenAuthNeeded() -> Bool {
        Task {
            await fetchNeedsBearerTokenAuth()
        }
        return bearerTokenAuthNeeded
    }
    // end TODO

    @objc dynamic var authenticated = false

    override init() {
        keychain = Keychain(service: "feedback2go.auth")
        super.init()
    }

    // TODO: remove after bearer token auth is gone
    func storeTokenInKeychain(token: String) {
        DispatchQueue.global().async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                    .set(token, key: "token")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func getTokenFromKeychain() {
        DispatchQueue.global().async {
            do {
                self.token = try self.keychain
                    .authenticationPrompt("Authenticate to login to App")
                    .get("token")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func deleteToken() {
        do {
            try keychain.remove("token")
            self.token = nil
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func parseAuth(data: Data) throws -> String {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode([String: String].self, from: data)
        guard let token = decodedData["id_token"] else {
            throw AuthenticationError.tokenNotFound
        }
        return token
    }
    // end TODO

    /// This Method allows the user to Authenticate. If it doesnt throw an Error the token will be set as a cookie
    /// If the rememberMe flag is set the token will be valid for 30 Days (if not 30 minutes)
    func auth(username: String, password: String, rememberMe: Bool = false) async throws {
        let body = AuthBody(username: username, password: password, rememberMe: rememberMe)
        let request = Request(method: .post, path: "/api/authenticate", body: body)
        if self.isBearerTokenAuthNeeded() {
            self.token = try await RESTController.shared.sendRequest(request) { try parseAuth(data: $0) }
        } else {
            try await RESTController.shared.sendRequest(request)
            checkAuth()
        }
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
