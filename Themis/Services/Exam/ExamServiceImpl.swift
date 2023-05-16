//
//  ExamServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import APIClient
import DesignLibrary

class ExamServiceImpl: ExamService {
    
    let client = APIClient()
    
    // MARK: - Get Exam For Assessment
    private struct GetExamForAssessmentRequest: APIRequest {
        typealias Response = Exam
        
        var courseId: Int
        var examId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/courses/\(courseId)/exams/\(examId)/exam-for-assessment-dashboard"
        }
    }
    
    func getExamForAssessment(courseId: Int, examId: Int) async throws -> Exam {
        try await client.sendRequest(GetExamForAssessmentRequest(courseId: courseId, examId: examId)).get().0
    }
}
