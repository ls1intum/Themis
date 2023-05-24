//
//  MockAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.05.23.
//

import Foundation
import SharedModels

class MockAssessmentViewModel: AssessmentViewModel {
    
    override init(readOnly: Bool) {
        super.init(readOnly: readOnly)
        self.submission = Submission.mockText.baseSubmission
    }
    
    override func initRandomSubmission(for exercise: Exercise) async {
        self.submission = Submission.mockText.baseSubmission
        assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
        self.showSubmission = true
        ThemisUndoManager.shared.removeAllActions()
    }
    
    override func getSubmission(for exercise: Exercise, participationOrSubmissionId: Int) async {
        if readOnly {
            self.submission = Submission.mockText.baseSubmission
            //                self.participation =
            //                assessmentResult.setComputedFeedbacks(basedOn: result.feedbacks ?? [])
        } else {
            self.submission = Submission.mockText.baseSubmission
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
            ThemisUndoManager.shared.removeAllActions()
        }
        self.showSubmission = true
    }
    
    override func cancelAssessment() async {
    }
    
    override func sendAssessment(submit: Bool) async {
    }
    
    override func notifyThemisML(exerciseId: Int) async {
    }
}
