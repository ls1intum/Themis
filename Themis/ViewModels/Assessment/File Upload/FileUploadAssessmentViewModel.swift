//
//  FileUploadAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 10.09.23.
//

import Foundation

class FileUploadAssessmentViewModel: AssessmentViewModel {
    @MainActor
    override func initSubmission() async {
        guard submission == nil else {
            return
        }
        
//        if readOnly {
//            self.error = UserFacingError.operationNotSupportedForExercise
//        } else {
//            if let participationId, let submissionId {
//                await getParticipationForSubmission(participationId: participationId, submissionId: submissionId)
//            } else {
//                await initRandomSubmission()
//            }
//        }
        
        ThemisUndoManager.shared.removeAllActions()
    }
}
