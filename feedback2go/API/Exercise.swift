//
//  Exercise.swift
//  feedback2go
//
//  Created by Tom Rudnick on 12.11.22.
//

import Foundation

struct Exercise: Codable {
    let id: Int
    let title: String?
    let shortName: String?
    let maxPoints: Double?
    let assessmentType: String?
    let problemStatement: String?
    let gradingInstructions: String? // For Programming Assesments this is nil
}

struct DueDateStat: Codable {
    let inTime: Int
    let late: Int
}
/// This Struct represents the Statstics for a an Exercise
struct ExerciseForAssessment: Codable {
    let numberOfStudent: Int?
    let numberOfSumissions: DueDateStat?
    let totalNumberOfAssessments: DueDateStat?
    let totalNumberOfAssessmentLocks: DueDateStat?
    let complaintsEnabled: Bool?
    let feedbackRequestEnabled: Bool?
    // let numberOfAssessmentsOfCorrectionRounds: DueDateStat? - this is an Array?!?! see ExerciseResource.java
    // let numberOfLockedAssessmentByOtherTutorsOfCorrectionRound: DueDateStat?
    let numberOfAutomaticAssistedAssessments: DueDateStat?

}

extension ArtemisAPI {
    static func getExercise(exerciseId: Int) async throws -> Exercise {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/for-assessment-dashboard")
        return try await sendRequest(Exercise.self, request: request)
    }

    static func getExerciseStats(exerciseId: Int) async throws -> ExerciseForAssessment {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/stats-for-assessment-dashboard")
        return try await sendRequest(ExerciseForAssessment.self, request: request)
    }
}
