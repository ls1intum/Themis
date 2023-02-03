//
//  ExerciseListItem.swift
//  Themis
//
//  Created by Paul Schwind on 23.01.23.
//

import SwiftUI

 struct ExerciseListItem: View {
    let exercise: Exercise
    let dateProperties: [ExerciseDateProperty]

    var body: some View {
        HStack {
            Text(exercise.title ?? "")
            Spacer()
            DateTimelineView(dates: dateProperties.map { dateProp in
                (name: dateProp.name, date: exercise[keyPath: dateProp.dateKeyPath])
            })
        }.padding(.trailing)
    }
 }
