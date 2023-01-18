import Foundation
import SwiftUI
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var submission: SubmissionForAssessment?
    @ObservedObject var assessmentResult = AssessmentResult()
    @Published var showSubmission = false
    @Published var readOnly = true
    @Published var loading = false

    init(readOnly: Bool) {
        self.readOnly = readOnly
    }

    @MainActor
    func initRandomSubmission(exerciseId: Int) async {
        loading = true
        defer {
            loading = false
        }
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: exerciseId)
            assessmentResult.computedFeedbacks = submission?.results?.last?.feedbacks ?? []
            self.showSubmission = true
        } catch {
            self.submission = nil
            print(error)
        }
    }

    @MainActor
    func getSubmission(id: Int) async {
        loading = true
        defer {
            loading = false
        }
        do {
            if readOnly {
                self.submission = try await ArtemisAPI.getSubmissionForReadOnly(participationId: id)
                assessmentResult.computedFeedbacks = submission?.feedbacks ?? []
            } else {
                self.submission = try await ArtemisAPI.getSubmissionForAssessment(submissionId: id)
                assessmentResult.computedFeedbacks = submission?.results?.last?.feedbacks ?? []
            }
            self.showSubmission = true
        } catch {
            print(error)
        }
    }

    @MainActor
    func cancelAssessment(submissionId: Int) async {
        loading = true
        defer {
            loading = false
        }
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
        loading = true
        defer {
            loading = false
        }
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
