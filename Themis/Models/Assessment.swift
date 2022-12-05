//
//  Assessment.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

enum FeedbackType {
    case inline
    case general
}

struct AssessmentResult: Encodable {
    var score: Double {
        feedbacks.reduce(0) { $0 + $1.credits }
    }
    var feedbacks: [AssessmentFeedback]

    enum CodingKeys: CodingKey {
        case score
        case feedbacks
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(score, forKey: .score)
        try container.encode(feedbacks, forKey: .feedbacks)
    }

    var generalFeedback: [AssessmentFeedback] {
        feedbacks.filter { $0.type == .general }
    }
    var inlineFeedback: [AssessmentFeedback] {
        feedbacks.filter { $0.type == .inline }
    }

    mutating func addFeedback(id: UUID = UUID(), detailText: String, credits: Double, type: FeedbackType,
                              file: Node? = nil, lines: NSRange? = nil, columns: NSRange? = nil) {
        feedbacks.append(AssessmentFeedback(id: id, detailText: detailText, credits: credits, type: type, file: file, lines: lines, columns: columns))
    }

    mutating func deleteFeedback(id: UUID) {
        feedbacks.removeAll { $0.id == id }
    }

    mutating func updateFeedback(id: UUID, detailText: String, credits: Double) {
        guard let index = (feedbacks.firstIndex { $0.id == id }) else {
            return
        }
        feedbacks[index].updateFeedback(detailText: detailText, credits: credits)
    }
}

struct AssessmentFeedback: Encodable, Identifiable {
    let id: UUID
    var text: String {
        guard let file = file, let lines = lines else {
            return ""
        }
        if lines.location == 0 {
            return ""
        }
        guard let columns = columns else {
            return file.name + " at Lines: \(lines.location)-\(lines.location + lines.length)"
        }
        if columns.length == 0 {
            return file.name + " at Line: \(lines.location) Col: \(columns.location)"
        }
        return file.name + " at Line: \(lines.location) Col: \(columns.location)-\(columns.location + columns.length)"
    } /// max length = 500
    var detailText: String /// max length = 5000
    var credits: Double /// score of element

    let type: FeedbackType
    var file: Node?
    var lines: NSRange?
    var columns: NSRange?

    enum CodingKeys: CodingKey {
        case text
        case detailText
        case credits
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(detailText, forKey: .detailText)
        try container.encode(credits, forKey: .credits)
    }

    mutating func updateFeedback(detailText: String, credits: Double) {
        self.detailText = detailText
        self.credits = credits
    }
}

enum FeedbackVisibility: String, Codable {
    case ALWAYS
    case AFTER_DUE_DATE
    case NEVER
}

extension ArtemisAPI {

    /// delete all saved feedback and release the lock of the submission
    static func cancelAssessment(submissionId: Int) async throws {
        let request = Request(method: .put, path: "/api/programming-submissions/\(submissionId)/cancel-assessment")
        _ = try await sendRequest(String.self, request: request)
    }

    /// save feedback to the submission
    static func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws {
        let request = Request(method: .put,
                              path: "/api/participations/\(participationId)/manual-results",
                              params: [URLQueryItem(name: "submit", value: String(submit))],
                              body: newAssessment)
        try await sendRequest(request: request)
    }
}
