//
//  FileUploadAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 10.09.23.
//

import Foundation
import Common

class FileUploadAssessmentViewModel: AssessmentViewModel {
    
    @MainActor
    override func initSubmission() async {
        guard submission == nil else {
            return
        }
        
        if readOnly {
            self.error = UserFacingError.operationNotSupportedForExercise
        } else {
            if let submissionId {
                await getSubmission(submissionId: submissionId)
            } else {
                await initRandomSubmission()
            }
        }
        
        ThemisUndoManager.shared.removeAllActions()
    }
    
    @MainActor
    override func saveAssessment() async {
        guard let submissionId else {
            return
        }
        
        loading = true
        defer { loading = false }
        
        do {
            let assessmentService = AssessmentServiceFactory.service(for: exercise)
            try await assessmentService.saveAssessment(submissionId: submissionId,
                                                       newAssessment: assessmentResult)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    override func submitAssessment() async {
        guard let submissionId else {
            return
        }
        
        loading = true
        defer { loading = false }
                
        do {
            let assessmentService = AssessmentServiceFactory.service(for: exercise)
            try await assessmentService.submitAssessment(submissionId: submissionId,
                                                         newAssessment: assessmentResult)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
}