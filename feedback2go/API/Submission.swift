//
//  Submission.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

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
    let repositoryUrl: String
    let userIndependentRepositoryUrl: String
}

struct Submission: Codable {
    let type: String
    let id: Int
    let submitted: Bool
    let participation: SubmissionParticipation
    let results: SubmissionResult
}

struct SubmissionForAssessment: Codable {
    let type: String
    let id: Int
    let submitted: Bool
    let participation: SubmissionParticipation
    let results: SubmissionResult
    let exercise: Exercise //TODO: Ask Tom for additional attributes in Exercise struct
}

/// Gets all submissions of that exercise. Response type: [Submission]
struct GetSubmissions: APIRequest {
    let exerciseId: Int
    var request: Request {
        Request(method: .get, path: "/api/exercises/\(exerciseId)/programming-submissions")
    }
}

/// Gets a random submission and locks it. This should be used to assess a random submission. Response type: SubmissionForAssessment
struct GetRandomSubmission: APIRequest {
    let exerciseId: Int
    var request: Request {
        Request(method: .get, path: "/api/exercises/\(exerciseId)/programming-submission-without-assessment?lock=true")
    }
}

/// Gets a submission associated with submissionId and locks it, so no one else can assess it. This should be used to assess a specific Submission. Response: SubmissionForAssessment
struct GetSubmission: APIRequest {
    let submissionId: Int
    var request: Request {
        Request(method: .get, path: "/api/programming-submissions/\(submissionId)/lock")
    }
}
