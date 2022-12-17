//
//  Assessment.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

// swiftlint:disable line_length

import Foundation

enum FeedbackType {
    case inline
    case general
}

struct AssessmentResult: Encodable {
    var score: Double {
        let score = feedbacks.reduce(0) { $0 + $1.credits }
        return score < 0 ? 0 : score
    }

    private var _feedbacks: [AssessmentFeedback] = []

    var feedbacks: [AssessmentFeedback] {
        get {
            _feedbacks
        }
        set(new) {
            _feedbacks = new.sorted(by: >).sorted { $0.assessmentType == .MANUAL && $1.assessmentType == .AUTOMATIC }
        }
    }

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
            .filter { $0.type == .general && $0.assessmentType == .MANUAL }
    }

    var inlineFeedback: [AssessmentFeedback] {
        feedbacks
            .filter { $0.type == .inline && $0.assessmentType == .MANUAL }
    }

    var automaticFeedback: [AssessmentFeedback] {
        feedbacks.filter { $0.assessmentType == .AUTOMATIC }
    }

    mutating func addFeedback(feedback: AssessmentFeedback) {
        feedbacks.append(feedback)
    }

    mutating func deleteFeedback(id: UUID) {
        feedbacks.removeAll { $0.id == id }
    }

    mutating func updateFeedback(id: UUID, feedback: AssessmentFeedback) {
        guard let index = (feedbacks.firstIndex { $0.id == id }) else {
            return
        }
        feedbacks[index] = feedback
    }
}

struct AssessmentFeedback: Identifiable {
    // attributes from artemis
    let id: UUID = UUID()
    let created: Date = Date()
    var text: String? /// max length = 500
    var detailText: String? /// max length = 5000
    var credits: Double /// score of element
    var assessmentType: AssessmentType = .MANUAL

    // custom utility attributes
    var type: FeedbackType
    var file: Node?

    init(
        text: String? = nil,
        detailText: String? = nil,
        credits: Double,
        assessmentType: AssessmentType = .MANUAL,
        type: FeedbackType,
        file: Node? = nil,
        lines: NSRange? = nil,
        columns: NSRange? = nil
    ) {
        self.text = text
        self.detailText = detailText
        self.credits = credits
        self.assessmentType = assessmentType
        self.type = type
        self.file = file
        self.buildLineDescription(lines: lines, columns: columns)
    }

    mutating func updateFeedback(detailText: String, credits: Double) {
        self.detailText = detailText
        self.credits = credits
    }

    mutating func buildLineDescription(lines: NSRange?, columns: NSRange?) {
        guard let file = file, let lines = lines else {
            return
        }
        if lines.location == 0 {
            return
        }
        guard let columns else {
            self.text = file.name + " at Lines: \(lines.location)-\(lines.location + lines.length)"
            return
        }
        if columns.length == 0 {
            self.text =  file.name + " at Line: \(lines.location) Col: \(columns.location)"
        } else {
            self.text = file.name + " at Line: \(lines.location) Col: \(columns.location)-\(columns.location + columns.length)"
        }
    }
}

// send to artemis
extension AssessmentFeedback: Encodable {
    enum EncodingKeys: String, CodingKey {
        case text
        case detailText
        case credits
        case assessmentType = "type"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(detailText, forKey: .detailText)
        try container.encode(credits, forKey: .credits)
        try container.encode(assessmentType, forKey: .assessmentType)
    }
}

// receive feedbacks from artemis
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
        assessmentType = try values.decode(AssessmentType.self, forKey: .assessmentType)
        type = text?.contains("at Line:") ?? false ? .inline : .general
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
