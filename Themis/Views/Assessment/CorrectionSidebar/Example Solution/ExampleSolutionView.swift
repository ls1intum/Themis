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
        case .fileUpload:
            if let fileUploadExercise = exercise?.baseExercise as? FileUploadExercise {
                ExampleFileUploadSolutionView(exercise: fileUploadExercise)
            }
        default:
            Text("This exercise does not support example solutions")
        }
    }
}

struct ExampleSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleSolutionView(exercise: Exercise.mockText)
            .frame(maxWidth: 350)
    }
}
