//
//  Exercise.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import Foundation

struct Participation: Codable {
    let id: Int
}

struct Exercise: Codable {
    let id: Int
    let title: String?
    let shortName: String?
    let maxPoints: Double?
    let assessmentType: String?
    let problemStatement: String?
    let gradingInstructions: String? // For Programming Assesments this might be nil
    let dueDate: String?
    let templateParticipation: Participation?
    // let solutionParticipation: Participation check again

    init() {
        self.id = -1
        self.title = nil
        self.shortName = nil
        self.maxPoints = nil
        self.assessmentType = nil
        self.problemStatement = nil
        self.gradingInstructions = nil
        self.dueDate = nil
        self.templateParticipation = Participation(id: -1)
    }

    func parseDate(_ dateString: String?) -> Date? {
        guard let dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }

    func getReadableDateString(_ dateString: String?) -> String {
        guard let date = parseDate(dateString) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
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
