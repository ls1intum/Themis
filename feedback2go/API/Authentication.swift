//
//  AuthenticationController.swift
//  feedback2go
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation
import KeychainAccess

class Authentication: NSObject {
    
    static var shared: Authentication!
    
    enum AuthenticationError: Error {
        case tokenNotFound
    }
    
    @objc dynamic var token: String?
    let keychain: Keychain
    
    override init() {
        keychain = Keychain(service: "feedback2go.auth")
    }
    
    func storeTokenInKeychain(token: String) {
        DispatchQueue.global().async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                    .set(token, key: "token")
            } catch (let error){
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
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteToken() {
        do {
            try keychain.remove("token")
            self.token = nil
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    ///This Method allows the user to Authenticate. If it doesnt throw an Error the Bearer token will be set
    func authenticate(username: String, password: String) async throws {
        let body = [
                    "username": username,
                    "password": password
                   ]
        let request = Request(method: .post, path: "/api/authenticate", body: body)
        self.token = try await RESTController.shared.sendRequest(request) { try parseAuth(data: $0) }
    }
    
    private func parseAuth(data: Data) throws -> String {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode([String: String].self, from: data)
        guard let token = decodedData["id_token"] else {
            throw AuthenticationError.tokenNotFound
        }
        return token
    }
}
