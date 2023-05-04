//
//  ExamSectionView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 07.02.23.
//

import SwiftUI
import SharedModels

struct ExamSectionView: View {
    let examID: Int
    let courseID: Int
    let examTitle: String
    
    @State var exercises: [Exercise] = []
    
    var body: some View {
        Form {
            Section("Exercise Groups") {
                ForEach(exercises) { exercise in
                    NavigationLink {
                        ExerciseView(exercise: exercise)
                    } label: {
                        HStack {
                            exercise.image
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: .smallImage)
                            
                            Text(exercise.baseExercise.title ?? "")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                    }
                    .disabled(exercise.disabled)
                }
            }
        }.task {
            let exam = try? await ArtemisAPI.getExamForAssessment(courseID: courseID, examID: examID)
            guard let exam else {
                return
            }
            self.exercises = exam.exercises
        }
        .navigationTitle(examTitle)
    }
}
