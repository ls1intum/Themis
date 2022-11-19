//
//  RESTError.swift
//  feedback2go
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

enum RESTError: String, Error {
    // TODO:add desc
    case unauthorized = "d"
    case badRequest = "a"
    case methodNotAllowed = "g"
    case forbidden = "h"
    case notFound = "j"
    case server = "k"
    case different = "r"
}
