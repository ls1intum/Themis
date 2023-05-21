//
//  CourseViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import Common
import SwiftUI
import SharedModels
import SharedServices

class CourseViewModel: ObservableObject {
    @Published var firstLoad = true
    @Published var loading = false
    @Published var courses: [Course] = []
    @Published var viewOnlyExercises: [Exercise] = []
    @Published var assessableExercises: [Exercise] = []
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
        courses = coursesForDashboard.value?.map({ $0.course }) ?? []
        
        if case .failure(let error) = coursesForDashboard {
            self.error = error
            log.error(String(describing: error))
        }
        
        if !pickerCourseIDs.contains(where: { $0 == shownCourseID }) {
            // can't use .first here due to double wrapped optional
            shownCourseID = pickerCourseIDs.isEmpty ? nil : pickerCourseIDs[0]
        }
    }
    
    @MainActor
    func fetchShownCourseAndSetExercises() async {
        guard let shownCourseID else {
            return
        }
        
        loading = true
        defer {
            loading = false
        }
        
        let courseForAssessment = await CourseServiceFactory.shared.getCourseForAssessment(courseId: shownCourseID)
        
        if case .failure(let error) = courseForAssessment {
            log.error(String(describing: error))
        }
        
        assessableExercises = (courseForAssessment.value?.exercises ?? []).filter({ $0.supportsAssessment })
        viewOnlyExercises = Array(Set(shownCourse?.exercises ?? []).subtracting(Set(assessableExercises))).filter({ $0.supportsAssessment })
    }
    
    func courseForID(id: Int) -> Course? {
        courses.first { $0.id == id }
    }
}
