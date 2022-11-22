//
//  Assessment.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

struct AssessmentResult: Codable {
    let score: Double /// total score
    let feedbacks: [AssessmentFeedback]
}

struct AssessmentFeedback: Codable {
    let text: String /// max length = 500
    let detailText: String /// max length = 5000
    let reference: String /// max length = 2000
    let credits: Double /// score of element
    let positive: Bool /// sign of score
    var type: String = "MANUAL"
    var visibility: FeedbackVisibility = .AFTER_DUE_DATE
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
        let request = Request(method: .post,
                              path: "/participations/\(participationId)/manual-results",
                              params: [URLQueryItem(name: "submit", value: String(submit))],
                              body: newAssessment)
        _ = try await sendRequest(String.self, request: request)
    }
}
