import Foundation
import SwiftUI
import Combine
import SharedModels

class AssessmentViewModel: ObservableObject {
    @Published var submission: BaseSubmission?
    /// Is set automatically when the submission is set
    @Published var participation: BaseParticipation?
    @Published var assessmentResult = AssessmentResult()
    @Published var showSubmission = false
    @Published var readOnly: Bool
    @Published var loading = false
    @Published var error: Error?
    
    private var cancellables: [AnyCancellable] = []

    init(readOnly: Bool) {
        self.readOnly = readOnly
        
        $submission
            .sink(receiveValue: { self.participation = $0?.participation?.baseParticipation })
            .store(in: &cancellables)
    }

    @MainActor
    func initRandomSubmission(exerciseId: Int) async {
        loading = true
        defer {
            loading = false
        }
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: exerciseId)
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
            self.showSubmission = true
            UndoManager.shared.removeAllActions()
        } catch {
            self.submission = nil
            self.error = error
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
                let result = try await ArtemisAPI.getResultFor(participationId: id)
                self.submission = result.submission?.baseSubmission
                self.participation = result.participation?.baseParticipation
                assessmentResult.setComputedFeedbacks(basedOn: result.feedbacks ?? [])
            } else {
                self.submission = try await ArtemisAPI.getSubmissionForAssessment(submissionId: id)
                assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
                UndoManager.shared.removeAllActions()
            }
            self.showSubmission = true
        } catch {
            self.error = error
        }
    }

    @MainActor
    func cancelAssessment() async {
        guard let submissionId = submission?.id else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        do {
            try await ArtemisAPI.cancelAssessment(submissionId: submissionId)
        } catch {
            if error as? RESTError != RESTError.empty {
                self.error = error
            }
        }
        self.submission = nil
        self.assessmentResult = AssessmentResult()
    }

    @MainActor
    func sendAssessment(submit: Bool) async {
        guard let participationId = participation?.id else {
            return
        }
        
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
            self.error = error
        }
    }
    
    func notifyThemisML(exerciseId: Int) async {
        guard let participationId = participation?.id else {
            return
        }
        
        do {
            try await ThemisAPI.notifyAboutNewFeedback(exerciseId: exerciseId, participationId: participationId)
        } catch {
            print(error)
        }
    }
}
