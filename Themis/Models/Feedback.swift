//
//  Feedback.swift
//  Themis
//
//  Created by Katjana Kosic on 19.11.22.
//

// Will be deleted in the future, as struct already exists in Assessment.swift

import Foundation

public enum FeedbackType: String, Codable {
    case general = "GENERAL"
    case inline = "INLINE"
}

public class Feedback: Identifiable {
    public var id: UUID
    public var filePath: String?
    public var type: FeedbackType
    public var feedbackText: String
    public var score: Double
    public var lineReference: Int?

    init(id: UUID? = nil, filePath: String? = nil, type: FeedbackType, feedbackText: String, score: Double, lineReference: Int? = nil) {
        self.id = id ?? UUID()
        self.filePath = filePath
        self.type = type
        self.feedbackText = feedbackText
        self.score = score
        self.lineReference = lineReference
    }
}
