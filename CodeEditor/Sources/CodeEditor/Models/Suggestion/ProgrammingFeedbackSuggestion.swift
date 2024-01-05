//
//  ProgrammingFeedbackSuggestion.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation
import SharedModels

public struct ProgrammingFeedbackSuggestion: FeedbackSuggestion, Decodable {
    
    public var id: Int
    
    public var exerciseId: Int
    
    public var submissionId: Int
    
    public var title: String
    
    public var description: String
    
    public var credits: Double
    
    public var structuredGradingInstructionId: Int?
    
    public var associatedAssessmentFeedbackId: UUID?
    
    public var filePath: String?
    
    public var lineStart: Int?
    
    public var lineEnd: Int?
}
