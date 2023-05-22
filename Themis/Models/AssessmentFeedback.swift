//
//  AssessmentFeedback.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation
import SharedModels

enum ThemisFeedbackScope {
    case inline
    case general
}

public struct AssessmentFeedback: Identifiable, Hashable {
    public var id = UUID()
    
    let created = Date()
    var baseFeedback: Feedback
    var scope: ThemisFeedbackScope
    var file: Node?

    init(
        baseFeedback: Feedback,
        scope: ThemisFeedbackScope,
        file: Node? = nil,
        lines: NSRange? = nil,
        columns: NSRange? = nil
    ) {
        self.baseFeedback = baseFeedback
        self.scope = scope
        self.file = file
        self.buildLineDescription(lines: lines, columns: columns)
    }

    mutating func updateFeedback(detailText: String, credits: Double) {
        self.baseFeedback.detailText = detailText
        self.baseFeedback.credits = credits
    }

    mutating func buildLineDescription(lines: NSRange?, columns: NSRange?) {
        guard let file = file, let lines = lines else {
            return
        }
        if lines.location == 0 {
            return
        }
        self.baseFeedback.reference = "file:" + file.path + "_line:\(lines.location)"
        
        guard let columns else {
            if lines.length == 0 {
                self.baseFeedback.text = "File " + file.path + " at line \(lines.location)"
            } else {
                self.baseFeedback.text = "File " + file.path + " at lines \(lines.location)-\(lines.location + lines.length)"
            }
            return
        }
        if columns.length == 0 {
            self.baseFeedback.text = "File " + file.path + " at line \(lines.location) column \(columns.location)"
        } else {
            self.baseFeedback.text = "File " + file.path + " at line \(lines.location) column \(columns.location)-\(columns.location + columns.length)"
        }
    }
}

extension AssessmentFeedback: Comparable {
    public static func < (lhs: AssessmentFeedback, rhs: AssessmentFeedback) -> Bool {
        lhs.created < rhs.created
    }
}


extension ArtemisAPI {

    /// delete all saved feedback and release the lock of the submission
    static func cancelAssessment(submissionId: Int) async throws {
        let request = Request(method: .put, path: "api/programming-submissions/\(submissionId)/cancel-assessment")
        _ = try await sendRequest(String.self, request: request)
    }

    /// save feedback to the submission
    static func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws {
        let request = Request(method: .put,
                              path: "api/participations/\(participationId)/manual-results",
                              params: [URLQueryItem(name: "submit", value: String(submit))],
                              body: newAssessment)
        try await sendRequest(request: request)
    }
}
