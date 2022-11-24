//
//  Submission.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

struct Student: Codable {
    let id: Int
    let login: String
    let name: String
    let email: String
}

struct SubmissionResult: Codable {
    let id: Int
    let score: Double
    let rated: Bool
    let hasFeedback: Bool
    let testCaseCount: Int
    let passedTestCaseCount: Int
    let codeIssueCount: Int
}

struct SubmissionParticipation: Codable {
    let id: Int
    let repositoryUrl: String
    let userIndependentRepositoryUrl: String
    let student: Student
}

struct Submission: Codable {
    let id: Int
    let participation: SubmissionParticipation
    let results: [SubmissionResult]
}

struct SubmissionForAssessment: Codable {
    let id: Int
    let participation: SubmissionParticipation
    let results: SubmissionResult
}

extension ArtemisAPI {
    /// Gets all submissions of that exercise assessed by the tutor = by the user.
    static func getTutorSubmissions(exerciseId: Int) async throws -> [Submission] {
        let request = Request(
            method: .get,
            path: "/api/exercises/\(exerciseId)/programming-submissions",
            params: [URLQueryItem(name: "assessedByTutor", value: "true")]
        )
        return try await sendRequest([Submission].self, request: request)
    }

    /// Gets a random submission and locks it. This should be used to assess a random submission.
    static func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> SubmissionForAssessment {
        let request = Request(
            method: .get,
            path: "/api/exercises/\(exerciseId)/programming-submission-without-assessment",
            params: [URLQueryItem(name: "lock", value: "true")]
        )
        return try await sendRequest(SubmissionForAssessment.self, request: request)
    }

    /// Gets a submission associated with submissionId and locks it, so no one else can assess it. This should be used to assess a specific Submission.
    static func getSubmissionForAssessment(submissionId: Int) async throws -> SubmissionForAssessment {
        let request = Request(method: .get, path: "/api/programming-submissions/\(submissionId)/lock")
        return try await sendRequest(SubmissionForAssessment.self, request: request)
    }
}
