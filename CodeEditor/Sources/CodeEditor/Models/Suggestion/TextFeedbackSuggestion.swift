//
//  TextFeedbackSuggestion.swift
//  
//
//  Created by Tarlan Ismayilsoy on 29.08.23.
//

import Foundation
import SharedModels

public struct TextFeedbackSuggestion: FeedbackSuggestion {
    public let id: Int
    
    public let exerciseId: Int
    
    public let submissionId: Int
    
    public let title: String
    
    public let description: String
    
    public let credits: Double
    
    public let structuredGradingInstructionId: Int?
    
    public var associatedAssessmentFeedbackId: UUID?
    
    public let indexStart: Int?
    
    public let indexEnd: Int?
    
    public var textBlockContent: String?
    
    public var isReferenced: Bool {
        indexStart != nil && indexEnd != nil
    }
    
    public var textBlock: TextBlock? {
        guard isReferenced else {
            return nil
        }
        return TextBlock(submissionId: submissionId, text: textBlockContent, startIndex: indexStart, endIndex: indexEnd)
    }
    
    public var feedback: Feedback {
        // TODO: grading instruction support
        return Feedback(text: Feedback.feedbackSuggestionAcceptedIdentifier + title,
                        detailText: description,
                        reference: textBlock?.id,
                        credits: credits,
                        type: isReferenced ? .MANUAL : .MANUAL_UNREFERENCED,
                        positive: credits > 0)
    }
    
    public mutating func setTextBlockContent(from submission: TextSubmission) {
        guard let indexStart,
              let indexEnd,
              let text = submission.text else {
            return
        }
        let nsRange = (indexStart ..< indexEnd).toNSRange()
        if let indexRange = Range(nsRange, in: text) {
            textBlockContent = String(text[indexRange])
        }
    }
}

public extension Feedback {
    static let feedbackSuggestionIdentifier = "FeedbackSuggestion:"
    static let feedbackSuggestionAcceptedIdentifier = "FeedbackSuggestion:accepted:"
    static let feedbackSuggestionAdaptedIdentifier = "FeedbackSuggestion:adapted:"
    
    var isSuggested: Bool {
        text?.hasPrefix(Self.feedbackSuggestionIdentifier) ?? false
    }
    
    var isSuggestedAndAccepted: Bool {
        text?.hasPrefix(Self.feedbackSuggestionAcceptedIdentifier) ?? false
    }
    
    var isSuggestedAndAdapted: Bool {
        text?.hasPrefix(Self.feedbackSuggestionAdaptedIdentifier) ?? false
    }
}
