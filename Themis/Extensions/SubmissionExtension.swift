//
//  SubmissionExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//
// swiftlint:disable identifier_name

import Foundation
import SharedModels

extension BaseSubmission {
    func getParticipation<T>(as: T.Type = BaseParticipation.self) -> T? {
        let participation = self.participation?.baseParticipation
        return participation as? T
    }
    
    func getExercise<T>(as: T.Type = (any BaseExercise).self) -> T? {
        self.getParticipation()?.getExercise(as: T.self)
    }
}

extension Submission {
    func getParticipation<T>(as: T.Type = BaseParticipation.self) -> T? {
        self.baseSubmission.getParticipation(as: T.self)
    }
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
    static func getRandomSubmissionForAssessment(exerciseId: Int) async throws -> ProgrammingSubmission {
        let request = Request(
            method: .get,
            path: "/api/exercises/\(exerciseId)/programming-submission-without-assessment",
            params: [URLQueryItem(name: "lock", value: "true")]
        )
        return try await sendRequest(ProgrammingSubmission.self, request: request)
    }

    /// Gets a submission associated with submissionId and locks it, so no one else can assess it. This should be used to assess a specific Submission.
    static func getSubmissionForAssessment(submissionId: Int) async throws -> ProgrammingSubmission {
        let request = Request(method: .get, path: "/api/programming-submissions/\(submissionId)/lock")
        return try await sendRequest(ProgrammingSubmission.self, request: request)
    }

    /// Gets a result associated with participationId without locking.
    static func getResultFor(participationId: Int) async throws -> Result {
        let request = Request(
            method: .get,
            path: "/api/programming-exercise-participations/\(participationId)/latest-result-with-feedbacks",
            params: [URLQueryItem(name: "withSubmission", value: "true")])

        return try await sendRequest(Result.self, request: request)
    }
}
