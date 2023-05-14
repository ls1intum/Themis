//
//  ExamExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation
import SharedModels

extension Exam {
    var isOver: Bool {
        if let endDate = self.endDate {
            return endDate <= .now
        }
        return false
    }
    
    public var exercises: [Exercise] {
        let exercises = exerciseGroups?.reduce([]) { $0 + ($1.exercises ?? []) } as? [Exercise]
        return exercises ?? []
    }
}

extension ArtemisAPI {
    static func getExams(courseID: Int) async throws -> [Exam] {
        let request = Request(method: .get, path: "api/courses/\(courseID)/exams")
        return try await sendRequest([Exam].self, request: request)
    }
    
    static func getExamForAssessment(courseID: Int, examID: Int) async throws -> Exam {
        let request = Request(method: .get, path: "api/courses/\(courseID)/exams/\(examID)/exam-for-assessment-dashboard")
        return try await sendRequest(Exam.self, request: request)
    }
}
