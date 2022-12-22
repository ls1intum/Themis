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
    let firstName: String
    let lastName: String?
    let email: String
    let name: String
}

struct SubmissionResult: Codable {
    let id: Int
    // let score: Double
    // let rated: Bool
    let hasFeedback: Bool?
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

struct ParticipationForAssessment: Codable {
    let id: Int
    let repositoryUrl: String
    let userIndependentRepositoryUrl: String
    let exercise: ExerciseOfSubmission
}

struct Submission: Codable, Identifiable {
    let id: Int
    let participation: SubmissionParticipation
    let results: [SubmissionResult]
}

struct ExerciseOfSubmission: Codable {
    let maxPoints: Double
    let problemStatement: String
    let gradingInstructions: String
    let gradingCriteria: [GradingCriterion]?
}

struct SubmissionForAssessment: Codable {
    let id: Int
    let participation: ParticipationForAssessment
    let feedbacks: [AssessmentFeedback]?
    let results: [SavedAssessmentResults]?
    let buildFailed: Bool
}

struct SavedAssessmentResults: Codable {
    let score: Double?
    let feedbacks: [AssessmentFeedback]
}

struct GradingCriterion: Codable, Identifiable {
    var id: Int
    var title: String?
    var structuredGradingInstructions: [GradingInstruction]
}

struct GradingInstruction: Codable, Identifiable {
    var id: Int
    var credits: Double
    var gradingScale: String
    var instructionDescription: String
    var feedback: String
    var usageCount: Int
}

struct ParticipationResult: Codable {
    let submission: SubmissionFromResult
    let feedbacks: [AssessmentFeedback]
    let participation: ParticipationForAssessment
}

struct SubmissionFromResult: Codable {
    let id: Int
    let buildFailed: Bool
}

extension ArtemisAPI {
    /// Gets all submissions of that exercise.
    static func getAllSubmissions(exerciseId: Int) async throws -> [Submission] {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/programming-submissions")
        return try await sendRequest([Submission].self, request: request)
    }

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

    /// Gets a submission associated with submissionId without locking it.
    static func getSubmissionForReadOnly(participationId: Int) async throws -> SubmissionForAssessment {
        let request = Request(
            method: .get,
            path: "/api/programming-exercise-participations/\(participationId)/latest-result-with-feedbacks",
            params: [URLQueryItem(name: "withSubmission", value: "true")])
        let pr = try await sendRequest(ParticipationResult.self, request: request)
        return SubmissionForAssessment(
            id: pr.submission.id,
            participation: pr.participation,
            feedbacks: pr.feedbacks,
            results: nil,
            buildFailed: pr.submission.buildFailed
        )
    }
}
