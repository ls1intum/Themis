import Foundation
import SwiftUI
import Combine
import SharedModels
import Common

class AssessmentViewModel: ObservableObject {
    @Published var submission: BaseSubmission?
    /// Is set automatically when the submission is set
    @Published var participation: BaseParticipation?
    @Published var assessmentResult = AssessmentResult()
    @Published var readOnly: Bool
    @Published var loading = false
    @Published var error: Error?
    @Published var pencilMode = true
    @Published var fontSize: CGFloat = 16.0
    
    var submissionId: Int?
    var participationId: Int?
    
    private var cancellables: [AnyCancellable] = []

    
    init(submissionId: Int? = nil, participationId: Int? = nil, readOnly: Bool) {
        self.submissionId = submissionId
        self.participationId = participationId
        self.readOnly = readOnly
        
        $submission
            .sink(receiveValue: { self.participation = $0?.participation?.baseParticipation })
            .store(in: &cancellables)
    }
    
    /// Resets some properties of this viewmodel that affect the toolbar
    func resetToolbarProperties() {
        pencilMode = true
        fontSize = 16.0
    }
    
    var gradingCriteria: [GradingCriterion] {
        participation?.getExercise()?.gradingCriteria ?? []
    }
    
    @MainActor
    func initSubmission(for exercise: Exercise) async {
        guard submission == nil else {
            return
        }
        
        if let submissionId {
            await getSubmission(for: exercise, submissionId: submissionId)
        } else if readOnly, let participationId {
            await getReadOnlySubmission(for: exercise, participationId: participationId)
        } else if !readOnly {
            await initRandomSubmission(for: exercise)
        }
        
        ThemisUndoManager.shared.removeAllActions()
    }

    @MainActor
    func initRandomSubmission(for exercise: Exercise) async {
        loading = true
        defer {
            loading = false
        }
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            self.submission = try await submissionService.getRandomSubmissionForAssessment(exerciseId: exercise.id)
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
            ThemisUndoManager.shared.removeAllActions()
        } catch {
            self.submission = nil
            self.error = error
            log.info(String(describing: error))
        }
    }

    @MainActor
    func getSubmission(for exercise: Exercise, submissionId: Int) async {
        guard !readOnly else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        let submissionService = SubmissionServiceFactory.service(for: exercise)
        
        do {
            self.submission = try await submissionService.getSubmissionForAssessment(submissionId: submissionId)
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
            ThemisUndoManager.shared.removeAllActions()
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    func getReadOnlySubmission(for exercise: Exercise, participationId: Int) async {
        guard readOnly else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        let submissionService = SubmissionServiceFactory.service(for: exercise)
        
        do {
            let result = try await submissionService.getResultFor(participationId: participationId)
            self.submission = result.submission?.baseSubmission
            self.participation = result.participation?.baseParticipation
            assessmentResult.setComputedFeedbacks(basedOn: result.feedbacks ?? [])
        } catch {
            self.error = error
            log.error(String(describing: error))
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
            try await AssessmentServiceFactory.shared.cancelAssessment(submissionId: submissionId)
        } catch {
            if error as? RESTError != RESTError.empty {
                self.error = error
                log.error(String(describing: error))
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
            try await AssessmentServiceFactory.shared.saveAssessment(
                participationId: participationId,
                newAssessment: assessmentResult,
                submit: submit
            )
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    func notifyThemisML(exerciseId: Int) async {
        guard let participationId = participation?.id else {
            return
        }
        
        do {
            try await ThemisAPI.notifyAboutNewFeedback(exerciseId: exerciseId, participationId: participationId)
        } catch {
            log.error(String(describing: error))
        }
    }
    
    func getFeedback(byId id: String) -> AssessmentFeedback? {
        assessmentResult.feedbacks.first(where: { "\($0.id)" == id })
    }
}
