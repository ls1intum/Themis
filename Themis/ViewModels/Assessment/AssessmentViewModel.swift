import Foundation
import SwiftUI
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var submission: SubmissionForAssessment?
    @Published var assessmentResult = AssessmentResult()
    @Published var showSubmission = false

    let readOnly: Bool

    init(readOnly: Bool) {
        self.readOnly = readOnly
    }

    @MainActor
    func initRandomSubmission(exerciseId: Int) async {
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: exerciseId)
            assessmentResult.feedbacks = submission?.results?.last?.feedbacks ?? []
            self.showSubmission = true
        } catch {
            print(error)
        }
    }

    @MainActor
    func getSubmission(id: Int) async {
        do {
            if readOnly {
                self.submission = try await ArtemisAPI.getSubmissionForReadOnly(participationId: id)
                assessmentResult.feedbacks = submission?.feedbacks ?? []
            } else {
                self.submission = try await ArtemisAPI.getSubmissionForAssessment(submissionId: id)
                assessmentResult.feedbacks = submission?.results?.last?.feedbacks ?? []
            }
            self.showSubmission = true
        } catch {
            print(error)
        }
    }

    @MainActor
    func cancelAssessment(submissionId: Int) async {
        do {
            try await ArtemisAPI.cancelAssessment(submissionId: submissionId)
        } catch {
            print(error)
        }
        self.submission = nil
        self.assessmentResult = AssessmentResult()
    }

    @MainActor
    func sendAssessment(participationId: Int, submit: Bool) async {
        do {
            try await ArtemisAPI.saveAssessment(
                participationId: participationId,
                newAssessment: assessmentResult,
                submit: submit
            )
        } catch {
            print(error)
        }
    }
}
