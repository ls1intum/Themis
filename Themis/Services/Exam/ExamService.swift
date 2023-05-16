//
//  ExamService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import Common

protocol ExamService {
    /// Fetch the exam for assessment
    func getExamForAssessment(courseId: Int, examId: Int) async throws -> Exam
}

enum ExamServiceFactory {
    
    static let shared: ExamService = ExamServiceImpl()
}
