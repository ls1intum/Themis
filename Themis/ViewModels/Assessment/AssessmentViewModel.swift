import Foundation
import SwiftUI
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var submission: SubmissionForAssessment?
    @Published var foundSubmission: Bool = false

    @MainActor
    func initRandomSubmission(exerciseId: Int) async {
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: 5284)
            self.foundSubmission = true
        } catch {
            print(error)
            return
        }
    }

}
