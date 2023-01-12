//
//  ExercisesListView.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

struct ExercisesListView: View {
    var exercises: [Exercise]?

    var body: some View {
        exercises.map { exerciseList in
            List {
                ForEach(exerciseList, id: \.id) { exercise in
                    NavigationLink {
                        ExerciseView(exercise: exercise)
                    } label: {
                        HStack {
                            Text(exercise.title ?? "")
                            Spacer()
                            Text("Due Date:")
                            Text(exercise.getReadableDateString(exercise.dueDate))
                        }
                    }
                }
            }
        }
    }
}
