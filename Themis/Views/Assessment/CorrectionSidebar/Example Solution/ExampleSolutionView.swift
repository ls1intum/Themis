//
//  ExampleSolutionView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 04.08.23.
//

import SwiftUI
import SharedModels

struct ExampleSolutionView: View {
    var exercise: Exercise?
    
    var body: some View {
        viewForExerciseType
    }
    
    @ViewBuilder
    private var viewForExerciseType: some View {
        switch exercise {
        case .text:
            if let textExercise = exercise?.baseExercise as? TextExercise {
                ExampleTextSolutionView(exercise: textExercise)
            }
        case .modeling:
            if let modelingExercise = exercise?.baseExercise as? ModelingExercise {
                ExampleModelingSolutionView(exercise: modelingExercise)
            }
        default:
            Text("This exercise does not support example solutions")
        }
    }
}
