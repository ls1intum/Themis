//
//  AssessmentService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import Common

protocol AssessmentService {
    /// Delete all saved feedback and release the lock of the submission
    func cancelAssessment(submissionId: Int) async throws
    
    /// Save feedback to the submission
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws
}

enum AssessmentServiceFactory {
    
    static let shared: AssessmentService = AssessmentServiceImpl()
}
