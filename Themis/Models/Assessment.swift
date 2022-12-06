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
        return feedbacks
            .filter { $0.type == .general }
            .sorted { $0.assessmentType == .MANUAL && $1.assessmentType == .AUTOMATIC }
            .sorted(by: >)
    }

    var inlineFeedback: [AssessmentFeedback] {
        feedbacks
            .filter { $0.type == .inline }
            .sorted(by: >)
    }

    mutating func addFeedback(detailText: String, credits: Double, type: FeedbackType, file: Node? = nil, lines: NSRange? = nil, columns: NSRange? = nil) -> AssessmentFeedback {
        let text = makeText(file: file, lines: lines, columns: columns)
        let feedback = AssessmentFeedback(text: text, detailText: detailText, credits: credits, type: type, file: file)
        feedbacks.append(feedback)
        return feedback
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

    func makeText(file: Node?, lines: NSRange?, columns: NSRange?) -> String? {
        guard let file = file, let lines = lines else {
            return nil
        }
        if lines.location == 0 {
            return nil
        }
        guard let columns = columns else {
            return file.name + " at Lines: \(lines.location)-\(lines.location + lines.length)"
        }
        if columns.length == 0 {
            return file.name + " at Line: \(lines.location) Col: \(columns.location)"
        }
        return file.name + " at Line: \(lines.location) Col: \(columns.location)-\(columns.location + columns.length)"
    }
}

struct AssessmentFeedback: Identifiable {
    // attributes from artemis
    let id: UUID = UUID()
    let created: Date = Date()
    var text: String? /// max length = 500
    var detailText: String? /// max length = 5000
    var credits: Double /// score of element
    var assessmentType: AssessmentType?

    // custom utility attributes
    var type: FeedbackType
    var file: Node?

    mutating func updateFeedback(detailText: String, credits: Double) {
        self.detailText = detailText
        self.credits = credits
    }
}

// make feedback encodable to send to artemis
extension AssessmentFeedback: Encodable {
    enum EncodingKeys: CodingKey {
        case text
        case detailText
        case credits
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(detailText, forKey: .detailText)
        try container.encode(credits, forKey: .credits)
    }
}

// make feedback decodable to receive feedbacks from artemis
extension AssessmentFeedback: Decodable {
    enum DecodingKeys: String, CodingKey {
        case text
        case detailText
        case credits
        case assessmentType = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        text = try? values.decode(String?.self, forKey: .text)
        detailText = try? values.decode(String?.self, forKey: .detailText)
        credits = try values.decode(Double?.self, forKey: .credits) ?? 0.0
        type = text?.contains("at Line:") ?? false ? .inline : .general
        // TODO: find a way to distinguish between automatic and manual feedback when fetching feedback for a specific submission
        assessmentType = try? values.decode(AssessmentType?.self, forKey: .assessmentType) ?? .MANUAL
    }
}

extension AssessmentFeedback: Comparable {
    static func < (lhs: AssessmentFeedback, rhs: AssessmentFeedback) -> Bool {
        lhs.created < rhs.created
    }
}

enum AssessmentType: String, Codable {
    case AUTOMATIC
    case SEMI_AUTOMATIC
    case MANUAL
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
