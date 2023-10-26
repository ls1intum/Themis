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
    
    public var gradingInstruction: GradingInstruction?
    
    public var associatedAssessmentFeedbackId: UUID?
    
    // TODO: rename/remove the fields below once programming suggestions are integrated into Athena
    public let participationId: Int
    public let srcFile: String
    public let fromLine: Int
    public let toLine: Int
    
    enum DecodingKeys: String, CodingKey {
        case exercise_id
        case participation_id
        case src_file
        case from_line
        case to_line
        case text
        case credits
    }

    // TODO: correct the decoding logic below once programming suggestions are integrated into Athena
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        id = Int.random(in: 1...999999)
        exerciseId = try values.decode(Int.self, forKey: .exercise_id)
        submissionId = -1
        title = "Suggestion"
        participationId = try values.decode(Int.self, forKey: .participation_id)
        srcFile = try values.decode(String.self, forKey: .src_file)
        fromLine = try values.decode(Int.self, forKey: .from_line)
        toLine = try values.decode(Int.self, forKey: .to_line)
        description = try values.decode(String.self, forKey: .text)
        credits = try values.decode(Double.self, forKey: .credits)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
