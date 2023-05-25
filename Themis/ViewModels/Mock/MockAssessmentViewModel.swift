//
//  MockAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.05.23.
//

import Foundation
import SharedModels

class MockAssessmentViewModel: AssessmentViewModel {
    
    override init(submissionId: Int? = nil, participationId: Int? = nil, readOnly: Bool) {
        super.init(readOnly: readOnly)
        self.submission = Submission.mockText.baseSubmission
    }
    
    override func initRandomSubmission(for exercise: Exercise) async {
        self.submission = Submission.mockText.baseSubmission
        assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
        ThemisUndoManager.shared.removeAllActions()
    }
    
    override func getSubmission(for exercise: Exercise, submissionId: Int) async {
        self.submission = Submission.mockText.baseSubmission
        assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
        ThemisUndoManager.shared.removeAllActions()
    }
    
    override func getReadOnlySubmission(for exercise: Exercise, participationId: Int) async {
        self.submission = Submission.mockText.baseSubmission
    }
    
    override func cancelAssessment() async {
    }
    
    override func sendAssessment(submit: Bool) async {
    }
    
    override func notifyThemisML(exerciseId: Int) async {
    }
}
