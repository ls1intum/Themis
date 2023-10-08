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
    static let noMoreAssessments = UserFacingError(title: "There aren't any unassessed submissions left")
    static let unknown = UserFacingError(title: "An unknown error occurred")
    
    // MARK: - Modeling
    static let diagramNotSupported = UserFacingError(title: "This UML diagram type is not supported")
    static let couldNotParseDiagram = UserFacingError(title: "Could not find UML diagram")
    
    // MARK: - File Upload
    static let couldNotFetchFileDetails = UserFacingError(title: """
        Could not fetch details of the uploaded file. The file URL may be invalid.
    """)
}
