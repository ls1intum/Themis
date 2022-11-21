//
//  Course.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 11.11.22.
//

import Foundation

struct Course: Codable {
    let id: Int
    let title: String?
    let description: String?
    let shortName: String?
    let exercises: [Exercise]?
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
