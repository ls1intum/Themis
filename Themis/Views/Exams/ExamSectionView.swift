//
//  ExamSectionView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 07.02.23.
//

import SwiftUI

struct ExamSectionView: View {
    var examID: Int
    var courseID: Int
    
    @State var exercises: [Exercise] = []
    
    var body: some View {
        Form {
            ExerciseSections(
                exercises: exercises
            )
        }.task {
            let exam = try? await ArtemisAPI.getExamForAssessment(courseID: courseID, examID: examID)
            guard let exam else { return }
            self.exercises = exam.exercises
        }
    }
}
