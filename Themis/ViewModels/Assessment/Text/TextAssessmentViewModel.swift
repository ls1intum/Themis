//
//  TextAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 29.07.23.
//

import Foundation
import Common
import SharedModels

class TextAssessmentViewModel: AssessmentViewModel {
    @MainActor
    override func initSubmission() async {
        guard submission == nil else {
            return
        }
        
        if readOnly {
            self.error = UserFacingError.operationNotSupportedForExercise
        } else {
            if let participationId, let submissionId {
                await getParticipationForSubmission(participationId: participationId, submissionId: submissionId)
            } else {
                await initRandomSubmission()
            }
        }
        
        ThemisUndoManager.shared.removeAllActions()
    }

    @MainActor
    private func getParticipationForSubmission(participationId: Int?, submissionId: Int?) async {
        guard let participationId, let submissionId else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        do {
            let assessmentService = AssessmentServiceFactory.service(for: exercise)
            let fetchedParticipation = try await assessmentService.fetchParticipationForSubmission(submissionId: submissionId).baseParticipation
            self.submission = fetchedParticipation.submissions?.last?.baseSubmission
            self.participation = fetchedParticipation
            assessmentResult.setComputedFeedbacks(basedOn: participation?.results?.last?.feedbacks ?? [])
            assessmentResult.setReferenceData(basedOn: submission)
            ThemisUndoManager.shared.removeAllActions()
        } catch {
            self.submission = nil
            self.error = error
            log.info(String(describing: error))
        }
    }

}
