//
//  PreviewAuthenticationViewModel.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

/// This is an AuthenticationViewModel you can use for the XCode preview feature.
/// Usually, you would have to somehow log in, but would be quite annoying and would also duplicate a lot of code.
/// Instead, you can just use a PreviewAuthenticationViewModel, which will automatically log in using credentials found in your environment.
/// For this to work, you have to edit the Themis scheme in XCode to include the following environment variables:
/// - ARTEMIS_STAGING_SERVER
/// - ARTEMIS_STAGING_USER
/// - ARTEMIS_STAGING_PASSWORD
/// Consult https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed for an explanation on how to configure them.

import Foundation

class PreviewAuthenticationViewModel: AuthenticationViewModel {
    static let SERVER_ENV_VAR = "ARTEMIS_STAGING_SERVER"
    static let USER_ENV_VAR = "ARTEMIS_STAGING_USER"
    static let PASSWORD_ENV_VAR = "ARTEMIS_STAGING_PASSWORD"

    init() {
        guard let serverURL = ProcessInfo.processInfo.environment[Self.SERVER_ENV_VAR] else {
            fatalError("Set \(Self.SERVER_ENV_VAR) in the environment to use PreviewAuthenticationViewModel.")
        }
        super.init(serverURL: serverURL)
        guard let username = ProcessInfo.processInfo.environment[Self.USER_ENV_VAR] else {
            fatalError("Set \(Self.USER_ENV_VAR) in the environment to use PreviewAuthenticationViewModel.")
        }
        self.username = username
        guard let password = ProcessInfo.processInfo.environment[Self.PASSWORD_ENV_VAR] else {
            fatalError("Set \(Self.PASSWORD_ENV_VAR) in the environment to use PreviewAuthenticationViewModel.")
        }
        self.password = password
        Task {
            await self.authenticate()
        }
    }
}
