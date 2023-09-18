//
//  ExamDetailViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.08.23.
//

import Foundation
import SharedModels
import Common

class ExamDetailViewModel: ObservableObject {
    @Published var exam: Exam?
    @Published var exercises: [Exercise] = []
    @Published var examTitle = "Exam"
    @Published var isLoading = false
    @Published var showNoExercisesInfo = false
    
    var courseId: Int
    var examId: Int
    
    init(courseId: Int, examId: Int) {
        self.courseId = courseId
        self.examId = examId
    }
    
    @MainActor
    func fetchExam() {
        isLoading = true
        
        Task { [weak self] in
            defer { self?.isLoading = false }
            
            let exam = try? await ExamServiceFactory.shared
                .getExamForAssessment(courseId: self?.courseId ?? -1, examId: self?.examId ?? -1)
            
            if let exam {
                self?.exam = exam
                self?.exercises = exam.exercises
                self?.examTitle = exam.title ?? ""
            } else {
                log.error("Could not fetch exam with id: \(examId) for course with id: \(courseId)")
            }
            
            if self?.exercises.isEmpty == true {
                self?.showNoExercisesInfo = true
            }
        }
    }
}
