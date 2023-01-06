//
//  CourseListViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    
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
        do {
            self.courses = try await ArtemisAPI.getAllCourses()
            if shownCourseID == nil {
                shownCourseID = self.courses.first?.id
            }
        } catch let error {
            print(error)
        }
    }

    func courseForID(id: Int) -> Course? {
        courses.first { $0.id == id }
    }
}
