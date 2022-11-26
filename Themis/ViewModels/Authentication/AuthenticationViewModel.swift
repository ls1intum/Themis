//
//  AuthenticationViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    /// This Variable is for the serverURL TextField
    /// Updating it will update the RESTController base URL and will save it in the User Defaults
    @Published var serverURL: String = "" {
        didSet {
            guard let url = URL(string: serverURL) else {
                return
            }
            UserDefaults.standard.set(serverURL, forKey: "serverURL")
            if restControllerInitialized {
                RESTController.shared.baseURL = url
            } else {
                RESTController.shared = RESTController(baseURL: url)
                restControllerInitialized = true
            }
        }
    }
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = true
    /// If this variable is true the User is authenticated
    @Published var authenticated: Bool = false
    /// If an 401 Error was catched, this alert will inform the User
    @Published var invalidCredentialsAlert: Bool = false
    /// While Authenticating this variable will be true for the ProgressView
    @Published var authenticationInProgress: Bool = false

    private var restControllerInitialized = false
    private var cancellable = Set<AnyCancellable>()

    init(serverURL: String) {
        self.serverURL = serverURL
        if let serverURL = URL(string: serverURL) {
            RESTController.shared = RESTController(baseURL: serverURL)
            restControllerInitialized = true
            Authentication.shared = Authentication(for: serverURL)
        }
        observeAuthenticationStatus()
        Authentication.shared.checkAuth()
    }

    convenience init() {
        self.init(serverURL: "https://artemis-staging.ase.in.tum.de")
    }

    /// Observing the Authentication Token will always change the @Published authenticated Bool  to the correct Value
    private func observeAuthenticationStatus() {
        Authentication.shared.publisher(for: \.authenticated, options: [.new])
            .receive(on: RunLoop.main)
            .sink { authenticated in
                self.authenticated = authenticated
            }
            .store(in: &cancellable)
    }

    @MainActor
    func authenticate() async {
        guard restControllerInitialized else {
            return
        }
        self.authenticationInProgress = true
        defer {
            self.authenticationInProgress = false
        }
        do {
            try await Authentication.shared.auth(username: username, password: password, rememberMe: rememberMe)
        } catch RESTError.unauthorized {
            self.invalidCredentialsAlert.toggle()
        } catch let error {
            // converting to string gives nicer errors,
            // see https://stackoverflow.com/a/68044439/4306257
            print(String(describing: error))
        }
    }

    /// Logs the User out by deleting the cookie
    func logout() async {
        do {
            try await Authentication.shared.logOut()
        } catch let error {
            print(error)
        }
    }
}
