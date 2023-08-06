//
//  ExampleModelingSolutionView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 06.08.23.
//

import SwiftUI
import SharedModels

struct ExampleModelingSolutionView: View {
    // swiftlint:disable all
    var exercise: ModelingExercise
    
    @StateObject private var umlRendererVM = UMLRendererViewModel()
    
    private let scale = 0.5
    
    var body: some View {
        UMLRenderer(umlRendererVM: umlRendererVM, showResetButton: false, scale: scale)
            .onChange(of: umlRendererVM.diagramSize, perform: { _ in
                umlRendererVM.setDragLocation(at: .init(x: umlRendererVM.currentDragLocation.x * 0.75,
                                                        y: umlRendererVM.currentDragLocation.y * scale * 0.75))
            })
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
