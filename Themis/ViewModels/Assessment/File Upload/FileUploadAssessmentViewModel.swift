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
            if let participationId {
                await getReadOnlySubmission(participationId: participationId)
            } else {
                self.error = UserFacingError.participationNotFound
                log.error("Could not find participation for file upload exercise: \(exercise.baseExercise.title ?? "")")
            }
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
    override func getReadOnlySubmission(participationId: Int) async {
        guard readOnly else {
            self.error = UserFacingError.unknown
            log.error("This function should only be called for read-only mode")
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            let response = try await submissionService.getSubmission(participationId: participationId)
            self.submission = response.baseSubmission
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
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
