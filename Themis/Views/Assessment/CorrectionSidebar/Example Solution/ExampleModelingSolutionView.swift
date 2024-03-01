//
//  ExampleModelingSolutionView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 06.08.23.
//

import SwiftUI
import SharedModels

struct ExampleModelingSolutionView: View {
    var exercise: ModelingExercise
    
    @StateObject private var umlRendererVM = UMLRendererViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let elements = umlRendererVM.umlModel?.elements, !elements.isEmpty {
                UMLRenderer(umlRendererVM: umlRendererVM)
                    .scaledToFit()
                    .clipped()
            } else {
                Text("Not available for this exercise.")
                    .font(.body)
            }
        }
        .onAppear {
            umlRendererVM.setup(basedOn: exercise.exampleSolutionModel ?? "")
        }
    }
}

struct ExampleModelingSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        if let exercise = Submission.mockModeling.baseSubmission.participation?.getExercise(as: ModelingExercise.self) {
            ExampleModelingSolutionView(exercise: exercise)
        }
    }
}
