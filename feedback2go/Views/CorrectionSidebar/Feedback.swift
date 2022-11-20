//
//  Feedback.swift
//  feedback2go
//
//  Created by Katjana Kosic on 19.11.22.
//

import Foundation

public class Feedback: Identifiable {
    public var id: UUID
    public var feedbackText: String
    public var score: Double

    init(id: UUID? = nil, feedbackText: String, score: Double) {
        self.id = id ?? UUID()
        self.feedbackText = feedbackText
        self.score = score
    }
}
