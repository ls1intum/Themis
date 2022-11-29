import Foundation
import SwiftUI
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var submission: SubmissionForAssessment?
    @Published var showSubmission: Bool = false

    @MainActor
    func initRandomSubmission(exerciseId: Int) async {
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: exerciseId)
            self.showSubmission = true
        } catch {
            print(error)
            return
        }
    }

    @MainActor
    func getSubmission(id: Int) async {
        do {
            self.submission = try await ArtemisAPI.getSubmissionForAssessment(submissionId: id)
            self.showSubmission = true
        } catch {
            print(error)
        }
    }
}
