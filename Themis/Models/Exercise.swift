//
//  Exercise.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//
// swiftlint:disable discouraged_optional_boolean

import Foundation

enum ExerciseType: String, Codable {
    case text = "TEXT"
    case programming = "PROGRAMMING"
    case modelling = "MODELING"
    case file_upload = "FILE_UPLOAD"
    case quiz = "QUIZ"
}

struct Exercise: Codable, Identifiable {
    let id: Int
    let title: String?
    let shortName: String?
    let maxPoints: Double?
    let assessmentType: String?
    let problemStatement: String?
    let gradingInstructions: String? // For Programming Assesments this might be nil
    var releaseDate: String?
    var dueDate: String?
    var assessmentDueDate: String?
    let templateParticipation: TemplateParticipation?
    let exerciseType: ExerciseType?
    
    var exerciseIconName: String? {
        guard let exerciseType else {
            return nil
        }
        switch exerciseType {
        case .programming:
            return "keyboard"
        case .text:
            return "character"
        case .modelling:
            return "flowchart"
        case .file_upload:
            return "folder"
        case .quiz:
            return "checkmark.bubble"
        }
    }
    
    var disabled: Bool {
        exerciseType == nil || exerciseType != .programming
    }

    init() {
        self.id = -1
        self.title = nil
        self.shortName = nil
        self.maxPoints = nil
        self.assessmentType = nil
        self.problemStatement = nil
        self.gradingInstructions = nil
        self.releaseDate = nil
        self.dueDate = nil
        self.assessmentDueDate = nil
        self.templateParticipation = nil
        self.exerciseType = nil
    }
    
    private func dateNow() -> String {
        ArtemisDateHelpers.stringifyDate(Date.now) ?? ""
    }
    
    func isFormer() -> Bool {
        if let assessmentDueDate, assessmentDueDate < dateNow() {
            return true
        }
        return false
    }
    
    func isCurrent() -> Bool {
        if let releaseDate, dateNow() < releaseDate {
            return false
        }
        if let assessmentDueDate, assessmentDueDate < dateNow() {
            return false
        }
        return true
    }
    
    func isFuture() -> Bool {
        // exercises without a release date are automatically published
        if let releaseDate, dateNow() < releaseDate {
            return true
        }
        return false
    }
}

struct DueDateStat: Codable {
    let inTime: Int
    let late: Int
}
/// This Struct represents the Statstics for a an Exercise
struct ExerciseForAssessment: Codable {
    let numberOfStudent: Int?
    let numberOfSubmissions: DueDateStat?
    let totalNumberOfAssessments: DueDateStat?
    // let totalNumberOfAssessments: DueDateStat?
    // let totalNumberOfAssessmentLocks: DueDateStat?
    let complaintsEnabled: Bool?
    let feedbackRequestEnabled: Bool?
    // let numberOfAssessmentsOfCorrectionRounds: DueDateStat? - this is an Array?!?! see ExerciseResource.java
    // let numberOfLockedAssessmentByOtherTutorsOfCorrectionRound: DueDateStat?
    // let numberOfAutomaticAssistedAssessments: DueDateStat?

}

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
    static func getExercise(exerciseId: Int) async throws -> Exercise {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/for-assessment-dashboard")
        return try await sendRequest(Exercise.self, request: request)
    }

    static func getExerciseStats(exerciseId: Int) async throws -> ExerciseForAssessment {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/stats-for-assessment-dashboard")
        return try await sendRequest(ExerciseForAssessment.self, request: request)
    }
    
    static func getExerciseStatsForDashboard(exerciseId: Int) async throws -> ExerciseStatistics {
        let request = Request(method: .get,
                              path: "api/management/statistics/exercise-statistics",
                              params: [URLQueryItem(name: "exerciseId", value: String(exerciseId))]
        )
        return try await sendRequest(ExerciseStatistics.self, request: request)
    }
}
