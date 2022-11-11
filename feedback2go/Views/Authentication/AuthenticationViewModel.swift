//
//  AuthenticationViewModel.swift
//  feedback2go
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var serverURL: String = "" {
        didSet {
            guard let serverURL = URL(string: serverURL) else { return }
            UserDefaults.standard.set(serverURL, forKey: "serverURL")
            if restControllerInitialized {
                RESTController.shared.baseURL = serverURL
            } else {
                RESTController.shared = RESTController(baseURL: serverURL)
                restControllerInitialized = true
            }
        }
    }
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var authenticated: Bool = false
    @Published var invalidCredentialsAlert: Bool = false
    @Published var authenticationInProgress: Bool = false
    
    private var restControllerInitialized = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        self.serverURL = UserDefaults.standard.string(forKey: serverURL) ?? "https://artemis.in.tum.de"
        if let serverURL = URL(string: serverURL) {
            RESTController.shared = RESTController(baseURL: serverURL)
            restControllerInitialized = true
        }
        Authentication.shared = Authentication()
        Authentication.shared.publisher(for: \.token, options: [.new])
            .receive(on: RunLoop.main)
            .sink { token in
                self.authenticated = token != nil
            }.store(in: &cancellable)
    }
    
    @MainActor
    func authenticate() async {
        guard restControllerInitialized else { return }
        self.authenticationInProgress = true
        defer {
            self.authenticationInProgress = false
        }
        do {
            try await Authentication.shared.authenticate(username: username, password: password)
            if let token = Authentication.shared.token {
                Authentication.shared.storeTokenInKeychain(token: token)
            }
        } catch (RESTError.unauthorized) {
            self.invalidCredentialsAlert.toggle()
        } catch (let error) {
            print(error.localizedDescription)
        }
        
    }
    func searchForToken () {
        Authentication.shared.getTokenFromKeychain ()
    }
    
    func logout() {
        Authentication.shared.deleteToken()
    }
}
