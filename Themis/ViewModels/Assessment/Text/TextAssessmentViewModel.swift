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
    private var suggestions = [TextFeedbackSuggestion]()
    
    private var shouldFetchSuggestions: Bool {
        !readOnly && submission?.isAssessed == false && assessmentResult.suggestedFeedback.isEmpty
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
            if let submissionId, participationId != nil {
                await getParticipationForSubmission(submissionId: submissionId)
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
            let response = try await submissionService.getSubmissionForAssessment(submissionId: submissionId, correctionRound: .first)
            self.submission = response
            assessmentResult.setComputedFeedbacks(basedOn: submission?.results?.last??.feedbacks ?? [])
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    private func getParticipationForSubmission(submissionId: Int?) async {
        guard let submissionId else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        do {
            let assessmentService = AssessmentServiceFactory.service(for: exercise)
            let fetchedParticipation = try await assessmentService
                .fetchParticipationForSubmission(submissionId: submissionId,
                                                 correctionRound: correctionRound).baseParticipation
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
    private func fetchSuggestions() async {
        guard let exerciseId = participation?.exercise?.id,
              let submissionId = submission?.id else {
            log.error("Could not fetch suggestions for submission: #\(submissionId ?? -1)")
            return
        }
        
        do {
            var fetchedSuggestions = try await AthenaService().getTextFeedbackSuggestions(exerciseId: exerciseId,
                                                                                          submissionId: submissionId)
            log.verbose("Fetched \(fetchedSuggestions.count) suggestions")
            
            fetchedSuggestions = setTextBlockContent(of: fetchedSuggestions)
            fetchedSuggestions = removeOverlappingSuggestions(fetchedSuggestions)
            
            self.suggestions = fetchedSuggestions
            saveSuggestionsAsAssessmentFeedbacks()
        } catch {
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    private func setTextBlockContent(of suggestions: [TextFeedbackSuggestion]) -> [TextFeedbackSuggestion] {
        guard let textSubmission = self.submission as? TextSubmission else {
            log.error("Expected a TextSubmission but got \(type(of: self.submission)) instead")
            return suggestions
        }
        
        var result = suggestions
        for index in 0 ..< suggestions.count {
            result[index].setTextBlockContent(from: textSubmission)
        }
        return result
    }
    
    @MainActor
    private func saveSuggestionsAsAssessmentFeedbacks() {
        var suggestedAssessmentFeedbacks = [AssessmentFeedback]()
        
        for index in 0 ..< suggestions.count {
            let suggestion = suggestions[index]
            
            var feedbackDetail: TextFeedbackDetail?
            if let suggestionTextBlock = suggestion.textBlock {
                feedbackDetail = TextFeedbackDetail(block: suggestionTextBlock)
            }
            
            let assessmentFeedback = AssessmentFeedback(baseFeedback: suggestion.feedback,
                                                        scope: suggestion.isReferenced ? .inline : .general,
                                                        detail: feedbackDetail)
            suggestedAssessmentFeedbacks.append(assessmentFeedback)
            suggestions[index].associatedAssessmentFeedbackId = assessmentFeedback.id
        }
        
        assessmentResult.computedFeedbacks += suggestedAssessmentFeedbacks
    }
    
    private func removeOverlappingSuggestions(_ suggestions: [TextFeedbackSuggestion]) -> [TextFeedbackSuggestion] {
        var rangeToSuggestion = [Range<Int>: TextFeedbackSuggestion]()
        var result = [TextFeedbackSuggestion]()
        
        for suggestion in suggestions {
            guard let startIndex = suggestion.indexStart,
                  let endIndex = suggestion.indexEnd else {
                result.append(suggestion) // preserve unreferenced suggestion
                continue
            }
            let range = startIndex..<endIndex
            
            let oldRanges = rangeToSuggestion.keys
            for oldRange in oldRanges {
                if oldRange.contains(range.lowerBound) || oldRange.contains(range.upperBound) {
                    continue // overlap detected
                }
            }
            
            rangeToSuggestion[range] = suggestion
        }
        
        result += Array(rangeToSuggestion.values)
        log.verbose("\(result.count) suggestions are remaining after removing overlaps")
        return result
    }
}
