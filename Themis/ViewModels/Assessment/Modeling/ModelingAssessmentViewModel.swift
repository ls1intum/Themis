//
//  ModelingAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 29.07.23.
//

import Foundation
import Common
import SharedModels

class ModelingAssessmentViewModel: AssessmentViewModel {
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
                log.error("Could not find participation for modeling exercise: \(exercise.baseExercise.title ?? "")")
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
        
        let submissionService = SubmissionServiceFactory.service(for: exercise)

        do {
            let response = try await submissionService.getSubmission(participationId: participationId)
            self.submission = response.baseSubmission
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
}
