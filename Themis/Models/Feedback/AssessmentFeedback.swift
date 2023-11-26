//
//  AssessmentFeedback.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation
import SharedModels
import CodeEditor

enum ThemisFeedbackScope {
    case inline
    case general
}

public struct AssessmentFeedback: Identifiable {
    public var id = UUID()
    
    let created = Date()
    var baseFeedback: Feedback
    var scope: ThemisFeedbackScope
    var detail: (any FeedbackDetail)?
    
    var isSuggested: Bool {
        baseFeedback.isSuggested
    }
    
    init(
        baseFeedback: Feedback = Feedback(),
        scope: ThemisFeedbackScope,
        detail: (any FeedbackDetail)? = nil
    ) {
        self.baseFeedback = baseFeedback
        self.scope = scope
        self.detail = detail
        self.detail?.buildArtemisFeedback(feedback: &self.baseFeedback)
    }

    mutating func setBaseFeedback(to feedback: Feedback) {
        self.baseFeedback = feedback
    }
    
    mutating func updateFeedback(detailText: String, credits: Double) {
        self.baseFeedback.detailText = detailText
        self.baseFeedback.credits = credits
    }
}

extension AssessmentFeedback: Comparable {
    public static func < (lhs: AssessmentFeedback, rhs: AssessmentFeedback) -> Bool {
        lhs.created < rhs.created
    }
}

extension AssessmentFeedback: Equatable, Hashable {
    public static func == (lhs: AssessmentFeedback, rhs: AssessmentFeedback) -> Bool {
        lhs.id == rhs.id
        && lhs.baseFeedback == rhs.baseFeedback
        && lhs.scope == rhs.scope
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(created)
        hasher.combine(baseFeedback)
        hasher.combine(scope)
    }
}

extension AssessmentFeedback {
    init(basedOn suggestion: any FeedbackSuggestion, _ incompleteFeedbackDetail: FeedbackDetail?, _ detailText: String, _ credits: Double) {
        var newIncompleteFeedbackDetail = incompleteFeedbackDetail
        
        if var incompleteFeedbackDetail = incompleteFeedbackDetail as? ProgrammingFeedbackDetail,
           let codeSuggestion = suggestion as? ProgrammingFeedbackSuggestion,
           let lineStart = codeSuggestion.lineStart,
           let lineEnd = codeSuggestion.lineEnd {
            let lines = NSRange(location: lineStart, length: lineEnd - lineStart)
            incompleteFeedbackDetail.lines = lines
            newIncompleteFeedbackDetail = incompleteFeedbackDetail
        }
        
        self.init(baseFeedback: Feedback(detailText: detailText,
                                         credits: credits,
                                         type: .MANUAL_UNREFERENCED),
                  scope: .inline,
                  detail: newIncompleteFeedbackDetail)
    }
}
