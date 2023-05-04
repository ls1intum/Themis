//
//  ExerciseListItem.swift
//  Themis
//
//  Created by Paul Schwind on 23.01.23.
//

import SwiftUI
import SharedModels

struct ExerciseListItem: View {
    let exercise: Exercise
    let dateProperties: [ExerciseDateProperty]

    var body: some View {
        HStack {
            Image(systemName: "keyboard")
                .font(.system(size: 23))
            
            Text(exercise.baseExercise.title ?? "")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
            DateTimelineView(dates: dateProperties.map { dateProp in
                (name: dateProp.name, date: exercise[keyPath: dateProp.dateKeyPath])
            })
        }
        .padding(.trailing)
    }
}
