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
    
    private enum CodingKeys: String, CodingKey {
        case block, feedback
    }
    
    public let id = UUID() // not decoded
}
