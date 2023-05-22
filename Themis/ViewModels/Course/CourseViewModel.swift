//
//  CourseViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import Common
import SwiftUI
import Common
import SharedModels
import SharedServices

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
    
    init() {
        // only way to check for non-existence:
        if UserDefaults.standard.object(forKey: Self.shownCourseIDKey) != nil {
            self.shownCourseID = UserDefaults.standard.integer(forKey: Self.shownCourseIDKey)
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
        
        let coursesForDashboard = await CourseServiceFactory.shared.getCourses()
        
        if case .failure(let error) = coursesForDashboard {
            self.error = error
            log.error(String(describing: error))
        }
        
        courses = coursesForDashboard.value?.map({ $0.course }).filter({ $0.isAtLeastTutorInCourse }) ?? []
        
        if !pickerCourseIDs.contains(where: { $0 == shownCourseID }) {
            // can't use .first here due to double wrapped optional
            shownCourseID = pickerCourseIDs.isEmpty ? nil : pickerCourseIDs[0]
        }
    }

    func courseForID(id: Int) -> Course? {
        courses.first { $0.id == id }
    }
}
