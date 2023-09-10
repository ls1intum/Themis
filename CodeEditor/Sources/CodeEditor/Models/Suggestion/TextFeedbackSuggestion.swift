//
//  TextFeedbackSuggestion.swift
//  
//
//  Created by Tarlan Ismayilsoy on 29.08.23.
//

import Foundation

public struct TextFeedbackSuggestion: FeedbackSuggestion {
    public let blockRef: TextBlockRef
    
    public var id: UUID {
        blockRef.associatedAssessmentFeedbackId ?? UUID()
    }
    
    public var text: String {
        blockRef.feedback.detailText ?? ""
    }
    
    public var credits: Double {
        blockRef.feedback.credits ?? 0.0
    }
    
    public init(blockRef: TextBlockRef) {
        self.blockRef = blockRef
    }
    
    public static func == (lhs: TextFeedbackSuggestion, rhs: TextFeedbackSuggestion) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text && lhs.credits == rhs.credits
    }
}
