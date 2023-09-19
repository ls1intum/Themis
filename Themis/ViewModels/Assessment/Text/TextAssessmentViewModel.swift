//
//  TextAssessmentViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 29.07.23.
//

import Foundation
import Common
import SharedModels
import CodeEditor

class TextAssessmentViewModel: AssessmentViewModel {
    private var suggestedBlockRefs = [TextBlockRef]()
    
    private var shouldFetchSuggestions: Bool {
        !readOnly && submission?.isAssessed == false && assessmentResult.automaticFeedback.isEmpty
    }
    
    @MainActor
    override func initSubmission() async {
        guard submission == nil else {
            return
        }
        
        if readOnly {
            if let submissionId {
                await getReadOnlySubmission(submissionId: submissionId)
            } else {
                self.error = UserFacingError.participationNotFound
                log.error("Could not find participation for text exercise: \(exercise.baseExercise.title ?? "")")
            }
        } else {
            if let participationId, let submissionId {
                await getParticipationForSubmission(participationId: participationId, submissionId: submissionId)
            } else {
                await initRandomSubmission()
            }
        }
        
        if shouldFetchSuggestions {
            await fetchSuggestions()
        }
        
        ThemisUndoManager.shared.removeAllActions()
    }
    
    @MainActor
    func getReadOnlySubmission(submissionId: Int) async {
        guard readOnly else {
            self.error = UserFacingError.unknown
            log.error("This function should only be called for read-only mode")
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            // We are not actually getting the submission for assessment, but this is the only endpoint that can be used to
            // get the submission based on the submissionId without locking it
            let response = try await submissionService.getSubmissionForAssessment(submissionId: submissionId)
            self.submission = response
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last?.feedbacks ?? [])
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }

    @MainActor
    private func getParticipationForSubmission(participationId: Int?, submissionId: Int?) async {
        guard let submissionId else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        do {
            let assessmentService = AssessmentServiceFactory.service(for: exercise)
            let fetchedParticipation = try await assessmentService.fetchParticipationForSubmission(submissionId: submissionId).baseParticipation
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
    
    private func fetchSuggestions() async {
        guard let exerciseId = participation?.exercise?.id,
              let submissionId = submission?.id else {
            log.error("Could not fetch suggestions for submission: #\(submissionId ?? -1)")
            return
        }
        
        do {
            var blockRefs = try await AthenaService().getFeedbackSuggestions(exerciseId: exerciseId, submissionId: submissionId)
            log.verbose("Fetched \(blockRefs.count) suggestions")
            
            blockRefs = removeOverlappingRefs(blockRefs)
            
            suggestedBlockRefs = blockRefs
            await saveBlockRefsAsAssessmentFeedbacks()
        } catch {
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    private func saveBlockRefsAsAssessmentFeedbacks() {
        var suggestedFeedbacks = [AssessmentFeedback]()
        
        for index in 0 ..< suggestedBlockRefs.count {
            let blockRef = suggestedBlockRefs[index]
            let assessmentFeedback = AssessmentFeedback(baseFeedback: blockRef.feedback,
                                                        scope: .inline,
                                                        detail: TextFeedbackDetail(block: blockRef.block))
            suggestedFeedbacks.append(assessmentFeedback)
            suggestedBlockRefs[index].associatedAssessmentFeedbackId = assessmentFeedback.id
        }
        
        assessmentResult.computedFeedbacks += suggestedFeedbacks
    }
    
    private func removeOverlappingRefs(_ blockRefs: [TextBlockRef]) -> [TextBlockRef] {
        var rangeToBlockRef = [Range<Int>: TextBlockRef]()
        
        for blockRef in blockRefs {
            guard let startIndex = blockRef.block.startIndex,
                  let endIndex = blockRef.block.endIndex else {
                continue
            }
            let blockRefRange = startIndex..<endIndex
            rangeToBlockRef[blockRefRange] = blockRef
        }
        
        let result = Array(rangeToBlockRef.values)
        log.verbose("\(result.count) suggestions are remaining after removing overlaps")
        return result
    }
    
    func getSuggestion(byAssessmentFeedbackId id: UUID) -> TextFeedbackSuggestion? {
        var suggestionBlockRef: TextBlockRef?
        
        if let blockRef = suggestedBlockRefs.first(where: { $0.associatedAssessmentFeedbackId == id }) {
            suggestionBlockRef = blockRef
        }
        // this happens when `fetchSuggestions()` is not called and automatic feedbacks embedded into the submission are used
        else if let assessmentFeedback = assessmentResult.automaticFeedback.first(where: { $0.id == id }),
                let textSubmission = submission as? TextSubmission,
                let blocks = textSubmission.blocks,
                let block = blocks.first(where: { $0.id == assessmentFeedback.baseFeedback.reference }) {
            var blockRef = TextBlockRef(block: block, feedback: assessmentFeedback.baseFeedback)
            blockRef.associatedAssessmentFeedbackId = id
            suggestionBlockRef = blockRef
        }
        
        if let suggestionBlockRef {
            return TextFeedbackSuggestion(blockRef: suggestionBlockRef)
        } else {
            return nil
        }
    }
}
