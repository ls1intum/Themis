//
//  ExerciseSections.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI
import SharedModels

struct ExerciseDateProperty: Hashable {
    let name: String
    let dateKeyPath: KeyPath<Exercise, Date?>
}

struct ExerciseSections: View {
    var exercises: [Exercise]
    
    private let dueDate = ExerciseDateProperty(name: "Submission", dateKeyPath: \.baseExercise.dueDate)
    private let assessmentDueDate = ExerciseDateProperty(name: "Assessment", dateKeyPath: \.baseExercise.assessmentDueDate)
    private let releaseDate = ExerciseDateProperty(name: "Release", dateKeyPath: \.baseExercise.releaseDate)
    
    var body: some View {
        Group {
            exerciseSection(
                title: "Exercises",
                dateProperties: [
                    releaseDate,
                    dueDate,
                    assessmentDueDate
                ],
                predicate: { $0 == $0 }
            )
            
//            exerciseSection(
//                title: "Exam Exercises",
//                dateProperties: [
//                    releaseDate,
//                    dueDate,
//                    assessmentDueDate
//                ],
//                predicate: { !$0.isCurrentlyInAssessment } // TODO:
//            )
        }
    }
    
    private var separator: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.tertiarySystemGroupedBackground))
            .frame(maxHeight: 1)
            .padding(.leading, .xl)
    }
    
    private func exerciseSection(
        title: String,
        dateProperties: [ExerciseDateProperty],
        predicate: (Exercise) -> Bool
    ) -> some View {
        let shownExercises = exercises
            .filter(predicate)
            .sorted(by: { $0.baseExercise.dueDate ?? .now < $1.baseExercise.dueDate ?? .now })
            
        return Group {
            if shownExercises.isEmpty {
                EmptyView()
            } else {
                Text(title)
                    .textCase(.uppercase)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                VStack {
                    ForEach(shownExercises, id: \.id) { exercise in
                        NavigationLink {
                            ExerciseView(exercise: exercise)
                        } label: {
                            ExerciseListItem(exercise: exercise, dateProperties: dateProperties)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                        }
                        .disabled(exercise.isDisabled)
                        
                        separator
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground).cornerRadius(10))
            }
        }
    }
}


struct ExercisesSectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSections(exercises: [])
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
