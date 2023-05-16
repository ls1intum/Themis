//
//  ExamService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import Common

public protocol ExamService {
    
    func getExamForAssessment(courseId: Int, examId: Int) async throws -> Exam
}

public enum ExamServiceFactory {
    
    public static let shared: ExamService = ExamServiceImpl()
}
