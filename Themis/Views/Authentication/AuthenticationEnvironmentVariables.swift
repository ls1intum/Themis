//
//  AuthenticationEnvironmentVariables.swift
//  Themis
//
//  Created by Paul Schwind on 02.12.22.
//

import Foundation

let stagingServer = ProcessInfo.processInfo.environment["ARTEMIS_STAGING_SERVER"]
let stagingUser = ProcessInfo.processInfo.environment["ARTEMIS_STAGING_USER"]
let stagingPassword = ProcessInfo.processInfo.environment["ARTEMIS_STAGING_PASSWORD"]
let bearerTokenAuth: Bool = ProcessInfo.processInfo.environment["USE_BEARER_TOKEN_AUTH"] == "true"
