//
//  ExamExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation
import SharedModels

extension Exam {
    public var exercises: [Exercise] {
        let exercises = exerciseGroups?.reduce([]) { $0 + ($1.exercises ?? []) } as? [Exercise]
        guard let exercises else {
            return []
        }
        return exercises.map { exercise in
            var exerciseWithDate = exercise
//            exerciseWithDate.baseExercise.releaseDate = self.startDate // TODO: find a solution around this
//            exerciseWithDate.baseExercise.dueDate = self.endDate
//            exerciseWithDate.baseExercise.assessmentDueDate = self.publishResultsDate
            return exerciseWithDate
        }
    }
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
