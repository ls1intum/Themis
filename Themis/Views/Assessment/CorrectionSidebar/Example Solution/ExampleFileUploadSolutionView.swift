//
//  ExampleFileUploadSolutionView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 26.09.23.
//

import SwiftUI
import SharedModels

struct ExampleFileUploadSolutionView: View {
    var exercise: FileUploadExercise
    
    var body: some View {
        Text("\(exercise.exampleSolution ?? "No example solution")")
    }
}

#Preview {
    if let exercise = Exercise.mockFileUpload.baseExercise as? FileUploadExercise {
        ExampleFileUploadSolutionView(exercise: exercise)
    } else {
        EmptyView()
    }
}
