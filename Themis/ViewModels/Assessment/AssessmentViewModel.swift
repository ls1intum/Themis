import Foundation
import SwiftUI
import Combine
import SharedModels
import Common

class AssessmentViewModel: ObservableObject {
    @Published var submission: BaseSubmission?
    /// Is set automatically when the submission is set
    @Published var participation: BaseParticipation?
    @Published var assessmentResult: AssessmentResult
    @Published var readOnly: Bool
    @Published var loading = false
    @Published var error: Error?
    @Published var pencilMode = true
    @Published var fontSize: CGFloat = 16.0
    
    var submissionId: Int?
    var participationId: Int?
    var resultId: Int?
    var exercise: Exercise
    
    private var cancellables: [AnyCancellable] = []
    
    init(exercise: Exercise, submissionId: Int? = nil, participationId: Int? = nil, resultId: Int? = nil, readOnly: Bool) {
        self.exercise = exercise
        self.submissionId = submissionId
        self.participationId = participationId
        self.resultId = resultId
        self.assessmentResult = AssessmentResultFactory.assessmentResult(for: exercise, resultIdFromServer: resultId)
        self.readOnly = readOnly
        
        $submission
            .sink(receiveValue: { self.participation = $0?.participation?.baseParticipation })
            .store(in: &cancellables)
        
        $participation
            .sink(receiveValue: { self.resultId = $0?.results?.last?.id })
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
    func initSubmission() async {
        guard submission == nil else {
            return
        }
        
        switch exercise {
        case .programming(exercise: _):
            if readOnly {
                if let participationId {
                    await getReadOnlySubmission(participationId: participationId)
                }
            } else {
                if let submissionId {
                    await getSubmission(submissionId: submissionId)
                } else {
                    await initRandomSubmission()
                }
            }
        case .text(exercise: _):
            if readOnly {
                // TODO: figure out which endpoint could be used instead
            } else {
                if let participationId, let submissionId {
                    await getParticipationForSubmission(participationId: participationId, submissionId: submissionId)
                } else {
                    await initRandomSubmission()
                }
            }
        default:
            log.warning("Attempt to assess an unknown exercise")
        }
        
        ThemisUndoManager.shared.removeAllActions()
    }
    
    @MainActor
    private func getParticipationForSubmission(participationId: Int?, submissionId: Int?) async {
        guard let participationId, let submissionId else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        do {
            let assessmentService = AssessmentServiceFactory.service(for: exercise)
            let fetchedParticipation = try await assessmentService.fetchParticipationForSubmission(participationId: participationId,
                                                                                                   submissionId: submissionId).baseParticipation
            self.submission = fetchedParticipation.submissions?.last?.baseSubmission
            self.participation = fetchedParticipation
            assessmentResult.setComputedFeedbacks(basedOn: participation?.results?.last?.feedbacks ?? [])
            assessmentResult.setReferenceData(basedOn: submission)
            ThemisUndoManager.shared.removeAllActions()
        } catch {
            self.submission = nil
            self.error = error
            log.info(String(describing: error))
        }
    }

    @MainActor
    func initRandomSubmission() async {
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
    func getSubmission(submissionId: Int) async {
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
    func getReadOnlySubmission(participationId: Int) async {
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
        
        let assessmentService = AssessmentServiceFactory.service(for: exercise)
        
        do {
            try await assessmentService.cancelAssessment(participationId: participationId, submissionId: submissionId)
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
    func saveAssessment() async {
        guard let participationId = participation?.id else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        let assessmentService = AssessmentServiceFactory.service(for: exercise)
        
        do {
            try await assessmentService.saveAssessment(participationId: participationId,
                                                       newAssessment: assessmentResult)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    func submitAssessment() async {
        guard let participationId = participation?.id else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        let assessmentService = AssessmentServiceFactory.service(for: exercise)
        
        do {
            try await assessmentService.submitAssessment(participationId: participationId,
                                                         newAssessment: assessmentResult)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    func notifyThemisML() async {
        guard let participationId = participation?.id else {
            return
        }
        
        do {
            try await ThemisAPI.notifyAboutNewFeedback(exerciseId: exercise.id, participationId: participationId)
        } catch {
            log.error(String(describing: error))
        }
    }
    
    func getFeedback(byId id: String) -> AssessmentFeedback? {
        assessmentResult.feedbacks.first(where: { "\($0.id)" == id })
    }
    
    func getFeedback(byReference reference: String) -> AssessmentFeedback? {
        assessmentResult.feedbacks.first(where: { $0.baseFeedback.reference == reference })
    }
}
