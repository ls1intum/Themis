import Foundation
import SwiftUI
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var submission: SubmissionForAssessment?

    var dismissPublisher = PassthroughSubject<Bool, Never>()
    private var dismissView = false {
        didSet {
            DispatchQueue.main.async {
                self.dismissPublisher.send(self.dismissView)
            }
        }
    }

    @MainActor
    func initRandomSubmission(exerciseId: Int) async {
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: 5284)
        } catch {
            print(error)
            self.dismissView = true
            return
        }
    }

}
