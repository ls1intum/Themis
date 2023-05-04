//
//  ExerciseForAssessment.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//
// swiftlint: disable discouraged_optional_boolean

import Foundation

/// Represents assessment-related statstics for an exercise
struct ExerciseStatsForAssessmentDashboard: Codable {
    let numberOfStudent: Int?
    let numberOfSubmissions: DueDateStat?
    let totalNumberOfAssessments: DueDateStat?
    let complaintsEnabled: Bool?
    let feedbackRequestEnabled: Bool?
}

struct DueDateStat: Codable {
    let inTime: Int
    let late: Int
}

extension ArtemisAPI {
    static func getExerciseStats(exerciseId: Int) async throws -> ExerciseStatsForAssessmentDashboard {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/stats-for-assessment-dashboard")
        return try await sendRequest(ExerciseStatsForAssessmentDashboard.self, request: request)
    }
}
