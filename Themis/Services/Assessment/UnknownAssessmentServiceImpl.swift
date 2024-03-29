//
//  UnknownAssessmentServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 31.05.23.
//

import Foundation
import SharedModels
import Common

class UnknownAssessmentServiceImpl: AssessmentService {
    
    func cancelAssessment(participationId: Int?, submissionId: Int) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func submitAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
}
