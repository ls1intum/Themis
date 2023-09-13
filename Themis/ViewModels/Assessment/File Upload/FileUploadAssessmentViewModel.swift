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
//            if let participationId {
//                await getReadOnlySubmission(participationId: participationId)
//            } else {
//                self.error = UserFacingError.participationNotFound
//                log.error("Could not find participation for modeling exercise: \(exercise.baseExercise.title ?? "")")
//            }
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
        
        let assessmentService = AssessmentServiceFactory.service(for: exercise)
        
        do {
            try await assessmentService.saveAssessment(submissionId: submissionId,
                                                       newAssessment: assessmentResult)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
}
