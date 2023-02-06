//
//  Course.swift
//  Themis
//
//  Created by Andreas Cselovszky on 11.11.22.
//

import Foundation

struct Course: Codable, Hashable {
    let id: Int
    let title: String
    let description: String?
    let shortName: String?
    var exercises: [Exercise]?
    var exams: [Exam]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    mutating func fetchProgrammingExercises(courseId: Int) async throws {
        exercises = try await ArtemisAPI.getAllProgrammingExercises(courseId: courseId)
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        // exercises are not equated
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.description == rhs.description && lhs.shortName == rhs.shortName
    }
}

extension ArtemisAPI {
    static func getAllCourses() async throws -> [Course] {
        let request = Request(method: .get, path: "/api/courses/for-dashboard")
        return try await sendRequest([Course].self, request: request)
    }

    static func getAllProgrammingExercises(courseId: Int) async throws -> [Exercise] {
        let request = Request(method: .get, path: "api/courses/\(courseId)/programming-exercises")
        return try await sendRequest([Exercise].self, request: request)
    }
}
