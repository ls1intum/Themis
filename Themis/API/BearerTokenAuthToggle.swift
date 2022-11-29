//
//  CookieAuthToggle.swift
//  Themis
//
//  Created by Paul Schwind on 29.11.22.
//

import Foundation

var bearerTokenAuth: Bool = ProcessInfo.processInfo.environment["USE_BEARER_TOKEN_AUTH"] == "true"
