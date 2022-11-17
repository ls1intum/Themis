//
//  Course.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 11.11.22.
//

import Foundation

struct CourseTitle: Codable {
    var title: String
}

struct GetCourseTitle: APIRequest {
    let courseID: String
    var request: Request {
        Request(method: .get, path: "/api/courses/\(courseID)")
    }
}
