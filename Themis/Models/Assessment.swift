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

    enum CodingKeys: CodingKey {
        case score
        case feedbacks
        case testCaseCount
        case passedTestCaseCount
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(score, forKey: .score)
        try container.encode(feedbacks.map({ $0.baseFeedback }), forKey: .feedbacks)
        try container.encode(automaticFeedback.count, forKey: .testCaseCount)
        try container.encode(automaticFeedback.filter { $0.baseFeedback.positive ?? false } .count, forKey: .passedTestCaseCount)
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

    func addFeedback(feedback: AssessmentFeedback) {
        if feedback.scope == .inline {
            undoManager.beginUndoGrouping() // undo group with addInlineHighlight in CodeEditorViewModel
        }
        computedFeedbacks.append(feedback)
    }

    func deleteFeedback(id: UUID) {
        if computedFeedbacks.contains(where: { $0.id == id && $0.scope == .inline }) {
             undoManager.beginUndoGrouping() // undo group with addInlineHighlight in CodeEditorViewModel
         }
        computedFeedbacks.removeAll { $0.id == id }
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
    
    func assignFile(id: UUID, file: Node) {
        guard let index = (feedbacks.firstIndex { $0.id == id }) else {
            return
        }
        computedFeedbacks[index].file = file
    }
}
