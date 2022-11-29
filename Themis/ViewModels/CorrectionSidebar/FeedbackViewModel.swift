//
//  FeedbackViewModel.swift
//  Themis
//
//  Created by Katjana Kosic on 19.11.22.
//

import Foundation
import Runestone
import UIKit

public class FeedbackViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []
    @Published var inlineHighlights: [String: [HighlightedRange]] = [:]

    var generalFeedbacks: [Feedback] {
        feedbacks.filter({ $0.type == .general })
    }
    var inlineFeedbacks: [Feedback] {
        feedbacks.filter({ $0.type == .inline })
    }

    func addFeedback(feedbackText: String, score: Double, type: FeedbackType, lineReference: Int?, file: Node?) {
        let newFeedback = Feedback(filePath: file?.path, type: type, feedbackText: feedbackText, score: score, lineReference: lineReference)
        feedbacks.append(newFeedback)
        // add higlighting to the line of the provided feedback
        if let file = file, let lineReference = lineReference, let lines = file.lines {
            if inlineHighlights.contains(where: { $0.key == file.path }) {
                inlineHighlights[file.path]?.append(HighlightedRange(id: newFeedback.id.uuidString,
                                                                     range: lines[lineReference - 1],
                                                                     color: UIColor.systemYellow,
                                                                     cornerRadius: 10))
            } else {
                inlineHighlights[file.path] = [HighlightedRange(id: newFeedback.id.uuidString,
                                                                range: lines[lineReference - 1],
                                                                color: UIColor.systemYellow,
                                                                cornerRadius: 10)]
            }
        }
    }

    public func deleteFeedback(id: Feedback.ID) {
        if let feedback = getFeedback(id: id), let filePath = feedback.filePath {
            inlineHighlights[filePath]?.removeAll(where: { $0.id == feedback.id.uuidString})
        }
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

    public func getFeedbackRef(id: Feedback.ID) -> Int? {
        guard let feedback = getFeedback(id: id) else {
            return nil
        }
        return feedback.lineReference
    }

    public static var mock: FeedbackViewModel {
        let mockModel = FeedbackViewModel()
        mockModel.addFeedback(feedbackText: "This is your feedback", score: -7.5, type: .general, lineReference: nil, file: nil)
        mockModel.addFeedback(feedbackText: "Second Feedback", score: -1.5, type: .general, lineReference: nil, file: nil)
        return mockModel
    }
}
