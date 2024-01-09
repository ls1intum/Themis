//
//  TextBlockRef.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 14.08.23.
//

import Foundation
import SharedModels

public struct TextBlockRef: Codable {
    public var block: TextBlock
    public var feedback: Feedback
    
    public init(block: TextBlock, feedback: Feedback) {
        self.block = block
        self.feedback = feedback
    }
    
    private enum CodingKeys: String, CodingKey {
        case block, feedback
    }
    
    public var associatedAssessmentFeedbackId: UUID? // not decoded
}
