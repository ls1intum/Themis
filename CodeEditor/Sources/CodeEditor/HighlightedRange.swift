//
//  File.swift
//  
//
//  Created by Tom Rudnick on 09.12.22.
//

import UIKit

/// Range of text to highlight.
public final class HighlightedRange {
    /// Unique identifier of the highlighted range.
    public let id: UUID
    /// Range in the text to highlight.
    public let range: NSRange
    /// Color to highlight the text with.
    public let color: UIColor
    /// enables distinction between normal and suggested feedbacks
    public let isSuggested: Bool

    /// Create a new highlighted range.
    /// - Parameters:
    ///   - id: ID of the range. Defaults to a UUID.
    ///   - range: Range in the text to highlight.
    ///   - color: Color to highlight the text with.
    public init(id: UUID = UUID(), range: NSRange, color: UIColor, isSuggested: Bool = false) {
        self.id = id
        self.range = range
        self.color = color
        self.isSuggested = isSuggested
    }
}

extension HighlightedRange: Equatable {
    public static func == (lhs: HighlightedRange, rhs: HighlightedRange) -> Bool {
        lhs.id == rhs.id && lhs.range == rhs.range && lhs.color == rhs.color
    }
}

extension HighlightedRange: CustomDebugStringConvertible {
    public var debugDescription: String {
        "[HighightedRange range=\(range)]"
    }
}
