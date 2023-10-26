//
//  FeedbackSuggestion.swift
//  
//
//  Created by Tarlan Ismayilsoy on 29.08.23.
//

import Foundation
import SharedModels

public protocol FeedbackSuggestion: Equatable, Decodable {
    var id: Int { get }
    var exerciseId: Int { get }
    var submissionId: Int { get }
    var title: String { get }
    var description: String { get }
    var credits: Double { get }
    var gradingInstruction: GradingInstruction? { get }
    
    var associatedAssessmentFeedbackId: UUID?  { get set } // not decoded
}
