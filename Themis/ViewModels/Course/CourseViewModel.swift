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
    @Published var viewOnlyExercises: [Exercise] = []
    @Published var assessableExercises: [Exercise] = []
    @Published var viewOnlyExams: [Exam] = []
    @Published var assessableExams: [Exam] = []
    @Published var error: Error?
    @Published var showCoursesIsEmptyMessage = false
    @Published var showExercisesIsEmptyMessage = false

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
        courses.map(\.id)
    }
    
    private var courses: [Course] = []
    
    init() {
        // only way to check for non-existence:
        if UserDefaults.standard.object(forKey: Self.shownCourseIDKey) != nil {
            self.shownCourseID = UserDefaults.standard.integer(forKey: Self.shownCourseIDKey)
        }
    }

    @MainActor
    func fetchAllCourses() {
        Task {
            if firstLoad {
                loading = true
            }
            defer {
                loading = false
            }
            
            let coursesForDashboard = await CourseServiceFactory.shared.getCourses()
            
            if case .failure(let error) = coursesForDashboard {
                self.error = error
                log.error(String(describing: error))
            }
            
            courses = coursesForDashboard.value?.courses?.map({ $0.course }).filter({ $0.isAtLeastTutorInCourse }) ?? []
            showCoursesIsEmptyMessage = courses.isEmpty
            
            if !pickerCourseIDs.contains(where: { $0 == shownCourseID }) {
                // can't use .first here due to double wrapped optional
                shownCourseID = pickerCourseIDs.isEmpty ? nil : pickerCourseIDs[0]
            }
            
            setExamsForShownCourse()
        }
    }
    
    @MainActor
    func fetchShownCourseAndSetExercises() {
        guard let shownCourseID else {
            return
        }
        
        Task { [weak self] in
            self?.loading = true
            self?.showExercisesIsEmptyMessage = false
            
            defer {
                self?.loading = false
                self?.showExercisesIsEmptyMessageIfNeeded()
            }
            
            let courseForAssessment = await CourseServiceFactory.shared.getCourseForAssessment(courseId: shownCourseID)
            
            if case .failure(let error) = courseForAssessment {
                log.error(String(describing: error))
            } else if let courseValueForAssessment = courseForAssessment.value {
                self?.setExercises(for: courseValueForAssessment)
                self?.setExamsForShownCourse()
            }
        }
    }
    
    func courseForID(id: Int) -> Course? {
        courses.first { $0.id == id }
    }
    
    private func setExercises(for shownCourse: Course) {
        let exercisesOfShownCourse = shownCourse.exercises ?? []
        
        assessableExercises = exercisesOfShownCourse.filter({ $0.isCurrentlyInAssessment })
        viewOnlyExercises = exercisesOfShownCourse.filter({ !$0.isCurrentlyInAssessment })
    }
    
    private func setExamsForShownCourse() {
        assessableExams = shownCourse?.exams?.filter({ $0.isOver && !$0.isAssessmentDue }) ?? []
        viewOnlyExams = shownCourse?.exams?.filter({ !$0.isOver || $0.isAssessmentDue }) ?? []
    }
    
    private func showExercisesIsEmptyMessageIfNeeded() {
        let allExercises = assessableExercises + viewOnlyExercises
        let allExams = assessableExams + viewOnlyExams
        showExercisesIsEmptyMessage = allExercises.isEmpty && allExams.isEmpty
    }
}
