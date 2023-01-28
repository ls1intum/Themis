//
//  RESTError.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import Foundation
import SwiftUI

enum RESTError: String, Error, LocalizedError {
    case unauthorized = "Request failed due to missing authentication."
    case badRequest = "Server didn't process request due to client error (e.g. wrong syntax)."
    case methodNotAllowed = "The HTTP Method is not allowed in this context."
    case forbidden = """
        You are not authorized to access this resource or perform this action.
        Please make sure you are logged in with the correct credentials and have the necessary permissions.
    """
    case notFound = "The requested ressource could not be found."
    case server = "The Server experienced an error, therefore not being able to respond."
    case empty = "The response was empty."
    case different = "Something went wrong while making a request."
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized access"
        case .badRequest:
            return "Bad request"
        case .methodNotAllowed:
            return "Method not allowed"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .server:
            return "Server error"
        case .empty:
            return "Empty response"
        case .different:
            return "An error occured"
        }
    }
    var recoverySuggestion: String? { rawValue.description }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError
        else {
            return nil
        }
        underlyingError = localizedError
    }
}

/// View modifier to show error alert.
extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(
            isPresented: .constant(
                localizedAlertError != nil
            ),
            error: localizedAlertError
        ) {_ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
