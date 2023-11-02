//
//  MockAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.05.23.
//

import Foundation
import SharedModels

class MockAssessmentViewModel: AssessmentViewModel {
    
    init(exercise: Exercise,
         submission: Submission,
         submissionId: Int? = nil,
         participationId: Int? = nil,
         resultId: Int? = nil,
         readOnly: Bool) {
        super.init(exercise: exercise,
                   submissionId: submissionId,
                   participationId: participationId,
                   resultId: resultId,
                   readOnly: readOnly)
        self.submission = submission.baseSubmission
    }
    
    override init(exercise: Exercise, submissionId: Int? = nil, participationId: Int? = nil, resultId: Int? = nil, readOnly: Bool) {
        super.init(exercise: exercise,
                   submissionId: submissionId,
                   participationId: participationId,
                   resultId: resultId,
                   readOnly: readOnly)
        self.submission = Submission.mockText.baseSubmission
    }
    
    override func initRandomSubmission() async {
        self.submission = Submission.mockText.baseSubmission
        assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last??.feedbacks ?? [])
        ThemisUndoManager.shared.removeAllActions()
    }
    
    override func getSubmission(submissionId: Int) async {
        self.submission = Submission.mockText.baseSubmission
        assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last??.feedbacks ?? [])
        ThemisUndoManager.shared.removeAllActions()
    }
    
    override func getReadOnlySubmission(participationId: Int) async {
        self.submission = Submission.mockText.baseSubmission
    }
    
    override func cancelAssessment() async {}
    
    override func saveAssessment() async {}
    
    override func submitAssessment() async {}
    
    override func notifyThemisML() async {}
}
