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
            VStack(alignment: .leading) {
                ForEach(dateProperties, id: \.self) { prop in
                    Text(prop.name + ": ")
                }
            }
            VStack(alignment: .leading) {
                ForEach(dateProperties, id: \.self) { prop in
                    let date = exercise[keyPath: prop.dateKeyPath]
                    let dateString = ArtemisDateHelpers.getReadableDateString(date) ?? "not yet available"
                    Text(dateString)
                }
            }
        }.padding(.trailing)
    }
}
