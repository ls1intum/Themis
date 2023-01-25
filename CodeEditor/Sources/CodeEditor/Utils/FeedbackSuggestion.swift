//
//  FeedbackSuggestion.swift
//  Themis
//
//  Created by Andreas Cselovszky on 25.01.23.
//

import Foundation

public struct FeedbackSuggestion: Decodable {
    let exerciseId: Int
    let participationId: Int
    let code: String
    public let srcFile: String
    let fromLine: Int
    let toLine: Int
    let text: String
    let credits: Double
    
    enum DecodingKeys: String, CodingKey {
        case exercise_id
        case participation_id
        case code
        case src_file
        case from_line
        case to_line
        case text
        case credits
    }
    
    public init(srcFile: String, fromLine: Int, toLine: Int) {
        self.exerciseId = -1
        self.participationId = -1
        self.code = ""
        self.srcFile = srcFile
        self.fromLine = fromLine
        self.toLine = toLine
        self.text = ""
        self.credits = 0
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        exerciseId = try values.decode(Int.self, forKey: .exercise_id)
        participationId = try values.decode(Int.self, forKey: .participation_id)
        code = try values.decode(String.self, forKey: .code)
        srcFile = try values.decode(String.self, forKey: .src_file)
        fromLine = try values.decode(Int.self, forKey: .from_line)
        toLine = try values.decode(Int.self, forKey: .to_line)
        text = try values.decode(String.self, forKey: .text)
        credits = try values.decode(Double.self, forKey: .credits)
    }
}
