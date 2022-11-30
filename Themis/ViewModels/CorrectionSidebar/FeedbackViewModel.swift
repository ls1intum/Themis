//
//  FeedbackViewModel.swift
//  Themis
//
//  Created by Katjana Kosic on 19.11.22.
//

import Foundation

public class FeedbackViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []

    public func deleteFeedback(id: Feedback.ID) {
        feedbacks.removeAll(where: { $0.id == id })
    }

    public func getFeedback(id: Feedback.ID?) -> Feedback? {
        if let id {
            return feedbacks.first(where: { $0.id == id })
        } else {
            return nil
        }
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

    public func saveFeedback(feedback: Feedback) {
        if let index = feedbacks.firstIndex(where: { $0.id == feedback.id }) {
            feedbacks[index] = feedback
        } else {
            feedbacks.append(feedback)
        }
    }

    public static var mock: FeedbackViewModel {
        let mockModel = FeedbackViewModel()
        mockModel.saveFeedback(feedback: Feedback(feedbackText: "This is your feedback", score: -7.5))
        mockModel.saveFeedback(feedback: Feedback(feedbackText: "Second Feedback", score: 3))

        return mockModel
    }
}
