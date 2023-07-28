//
//  ExerciseSection.swift
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

struct ExerciseSection: View {
    @EnvironmentObject var courseVM: CourseViewModel
    
    var exercises: [Exercise]
    
    private let releaseDate = ExerciseDateProperty(name: "Release", dateKeyPath: \.baseExercise.releaseDate)
    private let dueDate = ExerciseDateProperty(name: "Submission", dateKeyPath: \.baseExercise.dueDate)
    private let assessmentDueDate = ExerciseDateProperty(name: "Assessment", dateKeyPath: \.baseExercise.assessmentDueDate)
    
    private var shownExercises: [Exercise] {
        exercises.sorted(by: { $0.baseExercise.dueDate ?? .now < $1.baseExercise.dueDate ?? .now })
    }
    
    var body: some View {
        Group {
            if shownExercises.isEmpty {
                EmptyView()
            } else {
                Text("Exercises")
                    .customSectionTitle()
                
                VStack {
                    ForEach(shownExercises, id: \.self) { exercise in
                        NavigationLink {
                            ExerciseView(exercise: exercise)
                                .environmentObject(courseVM)
                        } label: {
                            ExerciseListItem(exercise: exercise, dateProperties: [releaseDate, dueDate, assessmentDueDate])
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                        }
                        .disabled(exercise.isDisabled)
                        
                        Divider()
                            .padding(.leading, .xl)
                            .isHidden(exercise == shownExercises.last, fake: true)
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground).cornerRadius(10))
            }
        }
    }
}


struct ExercisesSectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSection(exercises: [])
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
