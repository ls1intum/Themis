//
//  CourseViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI
import SharedModels

class CourseViewModel: ObservableObject {
    @Published var firstLoad = true
    @Published var loading = false
    @Published var courses: [Course] = []
    @Published var error: Error?
    
    private static var shownCourseIDKey = "shownCourseID"
    @Published var shownCourseID: Int? {
        didSet {
            guard let shownCourseID else {
                return
            }
            UserDefaults.standard.set(shownCourseID, forKey: Self.shownCourseIDKey)
        }
    }
    
    init() {
        // only way to check for non-existence:
        if UserDefaults.standard.object(forKey: Self.shownCourseIDKey) != nil {
            self.shownCourseID = UserDefaults.standard.integer(forKey: Self.shownCourseIDKey)
        }
    }
    
    var shownCourse: Course? {
        guard let shownCourseID else {
            return nil
        }
        return courseForID(id: shownCourseID)
    }
    
    var pickerCourseIDs: [Int?] {
        if shownCourseID == nil {
            return courses.map(\.id) + [nil]
        } else {
            return courses.map(\.id)
        }
    }

    @MainActor
    func fetchAllCourses() async {
        if firstLoad {
            loading = true
            firstLoad = false
        }
        defer {
            loading = false
        }
        do {
            self.courses = try await ArtemisAPI.getAllCourses()
            if shownCourseID == nil {
                shownCourseID = self.courses.first?.id
            }
        } catch let error {
            self.error = error
        }
    }

    func courseForID(id: Int) -> Course? {
        courses.first { $0.id == id }
    }
}
