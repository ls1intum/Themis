//
//  RESTError.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation

enum RESTError: String, Error {
    case unauthorized = "Request failed due to missing authentication."
    case badRequest = "Server didn't process request due to client error (e.g. wrong syntax)."
    case methodNotAllowed = "The HTTP Method is not allowed in this context."
    case forbidden = "Request failed due to insufficient permissions."
    case notFound = "The requested ressource could not be found."
    case server = "The Server experienced an error, therefore not being able to respond."
    case empty = "The response was empty."
    case different = "Some error occured while making a request."
}
