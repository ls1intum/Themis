//
//  PreviewAuthenticationViewModel.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//


import Foundation

/// This is an AuthenticationViewModel you can use for the XCode preview feature.
/// Usually, you would have to somehow log in, but would be quite annoying and would also duplicate a lot of code.
/// Instead, you can just use a PreviewAuthenticationViewModel, which will automatically log in using credentials found in your environment.
/// For this to work, you have to edit the Themis scheme in XCode to include the following environment variables:
/// - ARTEMIS_STAGING_SERVER
/// - ARTEMIS_STAGING_USER
/// - ARTEMIS_STAGING_PASSWORD
/// Consult https://confluence.ase.in.tum.de/display/IOS2223CIT/Authentication+Preview+Setup for an explanation on how to configure them.
/// (alternative for people without access: https://m25lazi.medium.com/environment-variables-in-xcode-a78e07d223ed)
class PreviewAuthenticationViewModel: AuthenticationViewModel {
    init() {
        guard let serverURL = stagingServer else {
            fatalError("Set the staging server in the environment to use PreviewAuthenticationViewModel.")
        }
        super.init(serverURL: serverURL)
        guard let username = stagingUser else {
            fatalError("Set the staging user in the environment to use PreviewAuthenticationViewModel.")
        }
        self.username = username
        guard let password = stagingPassword else {
            fatalError("Set the staging password in the environment to use PreviewAuthenticationViewModel.")
        }
        self.password = password
        Task {
            await self.authenticate()
        }
    }
}
