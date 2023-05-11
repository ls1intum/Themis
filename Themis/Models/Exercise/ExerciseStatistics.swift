//
//  ExerciseStatistics.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//

import Foundation

struct ExerciseStatistics: Codable {
    let averageScoreOfExercise: Double?
    let maxPointsOfExercise: Double?
    let scoreDistribution: [Int]?
    let numberOfExerciseScores: Int?
    let numberOfParticipations: Int?
    let numberOfStudentsOrTeamsInCourse: Int?
    let numberOfPosts: Int?
    let numberOfResolvedPosts: Int?
}

extension ArtemisAPI {
    static func getExerciseStatsForDashboard(exerciseId: Int) async throws -> ExerciseStatistics {
        let request = Request(method: .get,
                              path: "api/management/statistics/exercise-statistics",
                              params: [URLQueryItem(name: "exerciseId", value: String(exerciseId))]
        )
        return try await sendRequest(ExerciseStatistics.self, request: request)
    }
}
