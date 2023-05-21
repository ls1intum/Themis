//
//  CourseMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.05.23.
//

import SwiftUI
import SharedModels

extension Course {
    static var mock: Course {
        var mockCourse = Course(id: 1, courseInformationSharingConfiguration: .communicationAndMessaging)
        
        var baseProgEx1 = ProgrammingExercise(id: 1)
        baseProgEx1.title = "Mock Exercise 1"
        baseProgEx1.dueDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())
        baseProgEx1.releaseDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        baseProgEx1.assessmentDueDate = .tomorrow
        baseProgEx1.assessmentType = .automatic
        
        var baseProgEx2 = ProgrammingExercise(id: 2)
        baseProgEx2.title = "Mock Exercise 2"
        baseProgEx2.dueDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())
        baseProgEx2.releaseDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        baseProgEx2.assessmentDueDate = .tomorrow
        
        var baseProgEx3 = ProgrammingExercise(id: 3)
        baseProgEx3.title = "Mock Exercise 3"
        baseProgEx3.dueDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())
        baseProgEx3.releaseDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        baseProgEx3.assessmentDueDate = .tomorrow
        
        let exercises = [
            Exercise.programming(exercise: baseProgEx1),
            Exercise.programming(exercise: baseProgEx2),
            Exercise.programming(exercise: baseProgEx3)
        ]
        
        mockCourse.exercises = exercises
        
        return mockCourse
    }
}
