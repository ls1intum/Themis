//
//  UserFacingErrorExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 09.06.23.
//

import Common

extension UserFacingError {
    static let operationNotSupportedForExercise = UserFacingError(title: "This operation is not supported for this exercise")
    static let participationNotFound = UserFacingError(title: "Could not find participation")
    static let unknown = UserFacingError(title: "An unknown error occurred")
}
