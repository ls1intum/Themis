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
    @Published var serverURL: String {
        didSet {
            guard let url = generateURL(serverURL: serverURL) else {
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

    var validURL: Bool {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false }
        if let match = detector.firstMatch(in: serverURL, options: [], range: NSRange(location: 0, length: serverURL.utf16.count)) {
            return match.range.length == serverURL.utf16.count
        } else {
            return false
        }
    }

    var loginDisabled: Bool {
        !validURL || username.count < 1 || password.count < 1
    }

    @Published var username: String = stagingUser ?? ""
    @Published var password: String = stagingPassword ?? ""
    @Published var rememberMe = true
    /// If this variable is true the User is authenticated
    @Published var authenticated = false
    /// If an 401 Error was catched, this alert will inform the User
    @Published var invalidCredentialsAlert = false
    /// While Authenticating this variable will be true for the ProgressView
    @Published var authenticationInProgress = false

    private var restControllerInitialized = false
    private var cancellable = Set<AnyCancellable>()

    init(serverURL: String) {
        self.serverURL = serverURL
        if let serverURL = generateURL(serverURL: serverURL) {
            RESTController.shared = RESTController(baseURL: serverURL)
            restControllerInitialized = true
            Authentication.shared = Authentication()
        }
        observeAuthenticationToken() // TODO: remove once bearer token auth is no longer supported
        observeAuthenticationStatus()
        Authentication.shared.checkAuth()
    }

    private func generateURL(serverURL: String) -> URL? {
        guard let url = URL(string: serverURL) else { return nil }
        return cleanURL(url: url)
    }

    private func cleanURL(url: URL) -> URL? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let components else { return nil }
        var newComponents = URLComponents()
        newComponents.scheme = components.scheme
        newComponents.host = components.host
        return newComponents.url
    }

    convenience init() {
        self.init(serverURL: stagingServer ?? "https://artemis-staging.ase.in.tum.de")
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

    // TODO: remove after bearer token is gone
    private func observeAuthenticationToken() {
        Authentication.shared.publisher(for: \.token, options: [.new])
            .receive(on: RunLoop.main)
            .sink { token in
                self.authenticated = token != nil
            }
            .store(in: &cancellable)
    }
    // end TODO

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
            if Authentication.shared.isBearerTokenAuthNeeded() {
                if let token = Authentication.shared.token {
                    Authentication.shared.storeTokenInKeychain(token: token)
                }
            }
        } catch RESTError.unauthorized {
            self.invalidCredentialsAlert.toggle()
        } catch let error {
            // converting to string gives nicer errors,
            // see https://stackoverflow.com/a/68044439/4306257
            print(String(describing: error))
        }
    }

    // TODO: remove after bearer token is gone
    func searchForToken() {
        Authentication.shared.getTokenFromKeychain()
    }
    // end TODO

    /// Logs the User out by deleting the cookie
    func logout() async {
        if Authentication.shared.isBearerTokenAuthNeeded() {
            Authentication.shared.deleteToken()
        } else {
            do {
                try await Authentication.shared.logOut()
            } catch let error {
                print(error)
            }
        }
    }
}
