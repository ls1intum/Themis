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
    func cancelAssessment(participationId: Int?, submissionId: Int) async throws
    
    /// Save feedback to the submission based on the participation ID
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult) async throws
    
    /// Save feedback to the submission based on the submission ID
    func saveAssessment(submissionId: Int, newAssessment: AssessmentResult) async throws

    /// Submit the assessment based on the participation ID
    func submitAssessment(participationId: Int, newAssessment: AssessmentResult) async throws
    
    /// Submit the assessment based on the submission ID
    func submitAssessment(submissionId: Int, newAssessment: AssessmentResult) async throws
    
    /// Fetches the participation with all data needed for assessment
    func fetchParticipationForSubmission(submissionId: Int, correctionRound: Int) async throws -> Participation
}

extension AssessmentService { // Default implementations for some optional functions
    func saveAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func saveAssessment(submissionId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func submitAssessment(participationId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func submitAssessment(submissionId: Int, newAssessment: AssessmentResult) async throws {
        throw UserFacingError.operationNotSupportedForExercise
    }
    
    func fetchParticipationForSubmission(submissionId: Int, correctionRound: Int) async throws -> Participation {
        throw UserFacingError.operationNotSupportedForExercise
    }
}

enum AssessmentServiceFactory {
    static func service(for exercise: Exercise) -> any AssessmentService {
        switch exercise {
        case .programming:
            return ProgrammingAssessmentServiceImpl()
        case .text:
            return TextAssessmentServiceImpl()
        case .modeling:
            return ModelingAssessmentServiceImpl()
        case .fileUpload:
            return FileUploadAssessmentServiceImpl()
        default:
            return UnknownAssessmentServiceImpl()
        }
    }
}
