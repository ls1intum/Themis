//
//  FeedbackViewModel.swift
//  feedback2go
//
//  Created by Katjana Kosic on 19.11.22.
//

import Foundation

public class FeedbackViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []

    public func addFeedback(feedbackText: String, score: Double) {
        let newFeedback = Feedback(feedbackText: feedbackText, score: score)
        feedbacks.append(newFeedback)
    }

    public func deleteFeedback(id: Feedback.ID) {
        feedbacks.removeAll(where: { $0.id == id })
    }

    public func getFeedback(id: Feedback.ID) -> Feedback? {
        feedbacks.first(where: { $0.id == id })
    }

    public func getFeedbackText(id: Feedback.ID) -> String {
        guard let feedback = getFeedback(id: id) else {
            return "Error"
        }
        return feedback.feedbackText
    }

    public func getFeedbackScore(id: Feedback.ID) -> Double {
        guard let feedback = getFeedback(id: id) else {
            return 0.0
        }
        return feedback.score
    }

    public static var mock: FeedbackViewModel {
        let mockModel = FeedbackViewModel()
        mockModel.addFeedback(feedbackText: "This is your feedback", score: -7.5)
        mockModel.addFeedback(feedbackText: "Second Feedback", score: -1.5)
        return mockModel
    }
}
