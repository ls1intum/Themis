//
//  Exam.swift
//  Themis
//
//  Created by Tom Rudnick on 06.02.23.
//

import Foundation

struct Exam: Codable {
    let id: Int
    let title: String
    let startDate: String?
    let endDate: String?
    let publishResultsDate: String?
    var exerciseGroups: [ExerciseGroup]? //I don't know why this is an Array and wtf?
    
    var exercises: [Exercise] {
        let exercises = exerciseGroups?.reduce([]) { return $0 + ($1.exercises ?? []) } as? [Exercise]
        guard let exercises else { return [] }
        return exercises.map { exercise in
            var exerciseWithDate = exercise
            exerciseWithDate.releaseDate = self.startDate
            exerciseWithDate.dueDate = self.endDate
            exerciseWithDate.assessmentDueDate = self.publishResultsDate
            return exerciseWithDate
        }
    }
}


struct ExerciseGroup: Codable {
    let id: Int
    let title: String
    var exercises: [Exercise]?
}

extension ArtemisAPI {
    static func getExams(courseID: Int) async throws -> [Exam] {
        let request = Request(method: .get, path: "/api/courses/\(courseID)/exams")
        return try await sendRequest([Exam].self, request: request)
    }
    
    static func getExamForAssessment(courseID: Int, examID: Int) async throws -> Exam {
        let request = Request(method: .get, path: "/api/courses/\(courseID)/exams/\(examID)/exam-for-assessment-dashboard")
        return try await sendRequest(Exam.self, request: request)
    }
}
