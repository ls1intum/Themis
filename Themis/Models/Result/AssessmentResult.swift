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
    var allowedBonus = 0.0
    
    var points: Double {
        var instructionDict = [GradingInstruction: Int]()
        
        let score = feedbacks.reduce(0) { result, nextFeedback in
            if let instruction = nextFeedback.baseFeedback.gradingInstruction { // there's a grading instruction
                instructionDict[instruction] = (instructionDict[instruction] ?? 0) + 1
                
                if let limit = instruction.usageCount,
                   let currentCount = instructionDict[instruction],
                   limit == 0 || currentCount <= limit { // the limit is 0 (unlimited) or the limit is not exceeded
                    return result + (instruction.credits ?? 0.0)
                }
                
                return result // the limit is exceeded
            } else { // no grading instruction, just add the feedback credits
                return result + (nextFeedback.baseFeedback.credits ?? 0.0)
            }
        }
        
        return score.clamped(to: 0...maxPoints + allowedBonus)
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
        feedbacks.filter { $0.baseFeedback.type?.isAutomatic ?? false }
    }
    
    func reset() {
        self.computedFeedbacks.removeAll()
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
            undoManager.beginUndoGrouping() // undo group with deleteInlineHighlight in CodeEditorViewModel
        }
        
        computedFeedbacks.removeAll { $0.id == id }
        return feedbackToDelete
    }

    @discardableResult
    func updateFeedback(id: UUID,
                        detailText: String,
                        credits: Double,
                        instruction: GradingInstruction?) -> AssessmentFeedback? {
        guard let index = (feedbacks.firstIndex { $0.id == id }) else {
            return nil
        }
        computedFeedbacks[index].baseFeedback.detailText = detailText
        computedFeedbacks[index].baseFeedback.credits = credits
        computedFeedbacks[index].baseFeedback.gradingInstruction = instruction
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
        case .programming:
            return ProgrammingAssessmentResult()
        case .text:
            return TextAssessmentResult(resultId: resultIdFromServer)
        case .modeling:
            return ModelingAssessmentResult()
        case .fileUpload:
            return FileUploadAssessmentResult()
        default:
            return UnknownAssessmentResult()
        }
    }
}
