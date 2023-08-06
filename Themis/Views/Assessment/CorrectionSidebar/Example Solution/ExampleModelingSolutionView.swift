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
        VStack {
            UMLRenderer(umlRendererVM: umlRendererVM, showResetButton: false, scale: scale)
                .onChange(of: umlRendererVM.diagramSize, perform: { _ in
                    setDragLocationWithScale()
                })
                .onAppear {
                    umlRendererVM.setup(basedOn: exercise.exampleSolutionModel ?? "")
                }
            
            // The default reset button of UMLRenderer is replaced by the button below
            // because the default one is not shown properly when put inside a List
            centerButton
        }
    }
    
    @ViewBuilder
    private var centerButton: some View {
        Button {
            setDragLocationWithScale()
        } label: {
            HStack {
                Image(systemName: "scope")
                Text("Center")
            }
            .foregroundColor(.white)
        }
        .buttonStyle(ThemisButtonStyle())
    }
    
    private func setDragLocationWithScale() {
        umlRendererVM.setDragLocation() // center ignoring the scale first
        umlRendererVM.setDragLocation(at: .init(x: umlRendererVM.currentDragLocation.x * 0.75,
                                                y: umlRendererVM.currentDragLocation.y * scale * 0.75))
    }
}

struct ExampleModelingSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        if let exercise = Submission.mockModeling.baseSubmission.participation?.getExercise(as: ModelingExercise.self) {
            ExampleModelingSolutionView(exercise: exercise)
        }
    }
}
