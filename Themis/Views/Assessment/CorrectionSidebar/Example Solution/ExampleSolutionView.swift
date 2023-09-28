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
    var isLoading = false
    
    var body: some View {
        if isLoading {
            skeletonViewForExerciseType
        } else {
            viewForExerciseType
        }
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
    
    @ViewBuilder
    private var skeletonViewForExerciseType: some View {
        switch exercise {
        case .text:
            TextSkeleton()
        case .modeling:
            ModelingSkeleton()
                .frame(width: 280, height: 280)
        default:
            TextSkeleton()
        }
    }
}

struct ExampleSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleSolutionView(exercise: Exercise.mockText)
            .frame(maxWidth: 350)
    }
}
