//
//  ExampleTextSolutionView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 06.08.23.
//

import SwiftUI
import SharedModels

struct ExampleTextSolutionView: View {
    var exercise: TextExercise
    
    var body: some View {
        Text("\(exercise.exampleSolution ?? "No example solution")")
    }
}

struct ExampleTextSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        if let textExercise = Exercise.mockText.baseExercise as? TextExercise {
            ExampleTextSolutionView(exercise: textExercise)
        }
    }
}
