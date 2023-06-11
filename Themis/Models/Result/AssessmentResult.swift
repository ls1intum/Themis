//
//  Assessment.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation
import SharedModels

class AssessmentResult: Encodable, ObservableObject {
    let undoManager = ThemisUndoManager.shared
    
    var maxPoints = 100.0
    
    var points: Double {
        let score = feedbacks.reduce(0) { $0 + ($1.baseFeedback.credits ?? 0.0) }
        return score < 0 ? 0 : score
    }
    
    var score: Double {
        points / maxPoints * 100
    }

    @Published var feedbacks: [AssessmentFeedback] = [] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.feedbacks = oldValue
            }
        }
    }

    var computedFeedbacks: [AssessmentFeedback] {
        get {
            feedbacks
        }
        set(new) {
            feedbacks = new.sorted(by: >).sorted {
                $0.baseFeedback.type?.isManual == true && $1.baseFeedback.type?.isAutomatic == true
            }
        }
    }

    var generalFeedback: [AssessmentFeedback] {
        feedbacks
            .filter { $0.scope == .general && $0.baseFeedback.type?.isManual ?? false }
    }

    var inlineFeedback: [AssessmentFeedback] {
        feedbacks
            .filter { $0.scope == .inline && $0.baseFeedback.type?.isManual ?? false }
    }

    var automaticFeedback: [AssessmentFeedback] {
        feedbacks.filter { $0.baseFeedback.type?.isAutomatic ?? false && $0.baseFeedback.credits != 0 }
    }
    
    func setComputedFeedbacks(basedOn feedbacks: [Feedback]) {
        computedFeedbacks = feedbacks
            .map { feedback in
                let scope = (feedback.reference == nil) ? ThemisFeedbackScope.general : ThemisFeedbackScope.inline
                return AssessmentFeedback(baseFeedback: feedback, scope: scope)
            }
    }
    
    /// Sets reference-related data for this assessment result. Intended to be overridden by subclasses.
    func setReferenceData(basedOn submission: BaseSubmission?) {}
    
    func getFeedback(byId id: UUID) -> AssessmentFeedback? {
        computedFeedbacks.first(where: { $0.id == id })
    }

    func addFeedback(feedback: AssessmentFeedback) {
        if feedback.scope == .inline {
            undoManager.beginUndoGrouping() // undo group with addInlineHighlight in CodeEditorViewModel
        }
        computedFeedbacks.append(feedback)
    }

    @discardableResult
    func deleteFeedback(id: UUID) -> AssessmentFeedback? {
        guard let feedbackToDelete = computedFeedbacks.first(where: { $0.id == id }) else {
            return nil
        }
        
        if feedbackToDelete.scope == .inline {
            undoManager.beginUndoGrouping() // undo group with addInlineHighlight in CodeEditorViewModel
        }
        
        computedFeedbacks.removeAll { $0.id == id }
        return feedbackToDelete
    }

    @discardableResult
    func updateFeedback(id: UUID, detailText: String, credits: Double) -> AssessmentFeedback? {
        guard let index = (feedbacks.firstIndex { $0.id == id }) else {
            return nil
        }
        computedFeedbacks[index].baseFeedback.detailText = detailText
        computedFeedbacks[index].baseFeedback.credits = credits
        return computedFeedbacks[index]
    }
    
    @discardableResult
    func updateFeedback(feedback: AssessmentFeedback) -> AssessmentFeedback? {
        guard let index = (feedbacks.firstIndex { $0.id == feedback.id }) else {
            return nil
        }
        computedFeedbacks[index] = feedback
        return feedback
    }
    
    func encode(to encoder: Encoder) throws {} // to be overridden by subclasses
}

enum AssessmentResultFactory {
    static func assessmentResult(for exercise: Exercise, resultIdFromServer: Int? = nil) -> AssessmentResult {
        switch exercise {
        case .programming(exercise: _):
            return ProgrammingAssessmentResult()
        case .text(exercise: _):
            return TextAssessmentResult(resultId: resultIdFromServer)
        default:
            return UnknownAssessmentResult()
        }
    }
}
