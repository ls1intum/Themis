//
//  ProgrammingFeedbackSuggestion.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation
import SharedModels

public struct ProgrammingFeedbackSuggestion: FeedbackSuggestion, Decodable {
    public let id = UUID()
    public let exerciseId: Int
    public let participationId: Int
    public let srcFile: String
    public let fromLine: Int
    public let toLine: Int
    public let text: String
    public let credits: Double
    
    enum DecodingKeys: String, CodingKey {
        case exercise_id
        case participation_id
        case src_file
        case from_line
        case to_line
        case text
        case credits
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        exerciseId = try values.decode(Int.self, forKey: .exercise_id)
        participationId = try values.decode(Int.self, forKey: .participation_id)
        srcFile = try values.decode(String.self, forKey: .src_file)
        fromLine = try values.decode(Int.self, forKey: .from_line)
        toLine = try values.decode(Int.self, forKey: .to_line)
        text = try values.decode(String.self, forKey: .text)
        credits = try values.decode(Double.self, forKey: .credits)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
