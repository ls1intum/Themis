//
//  ExerciseSections.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

struct ExerciseDateProperty: Hashable {
    let name: String
    let dateKeyPath: KeyPath<Exercise, String?>
}

struct ExerciseSections: View {
    var exercises: [Exercise]
    
    private let dueDate = ExerciseDateProperty(name: "Submission", dateKeyPath: \.dueDate)
    private let assessmentDueDate = ExerciseDateProperty(name: "Assessment", dateKeyPath: \.assessmentDueDate)
    private let releaseDate = ExerciseDateProperty(name: "Release", dateKeyPath: \.releaseDate)
    
    var body: some View {
        Group {
            exerciseSection(
                title: "Former Exercises",
                dateProperties: [
                    releaseDate,
                    dueDate,
                    assessmentDueDate
                ],
                predicate: { $0.isFormer() }
            )
            
            exerciseSection(
                title: "Current Exercises",
                dateProperties: [
                    releaseDate,
                    dueDate,
                    assessmentDueDate
                ],
                predicate: { $0.isCurrent() }
            )
            
            exerciseSection(
                title: "Future Exercises",
                dateProperties: [
                    releaseDate,
                    dueDate,
                    assessmentDueDate
                ],
                predicate: { $0.isFuture() }
            )
        }
    }
    
    private func exerciseSection(
        title: String,
        dateProperties: [ExerciseDateProperty],
        predicate: (Exercise) -> Bool
    ) -> some View {
        let shownExercises = exercises
            .filter(predicate)
            .sorted {
                ArtemisDateHelpers.parseDate($0.dueDate) ?? Date.now <
                    ArtemisDateHelpers.parseDate($1.dueDate) ?? Date.now
            }
        return Group {
            if shownExercises.isEmpty {
                EmptyView()
            } else {
                Section(header: HStack {
                    Text(title)
                    Spacer()
                }) {
                    ForEach(shownExercises, id: \.id) { exercise in
                        NavigationLink {
                            ExerciseView(dateProperties: dateProperties, exercise: exercise)
                        } label: {
                            ExerciseListItem(exercise: exercise, dateProperties: dateProperties)
                        }
                    }
                }
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
