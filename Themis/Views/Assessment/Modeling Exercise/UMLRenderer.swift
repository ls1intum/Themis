//
//  UMLRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import SwiftUI
import SharedModels
import Common

struct UMLRenderer: View {
    @StateObject private var umlRendererVM = UMLRendererViewModel()
    var modelString: String
    
    var body: some View {
        ZStack {
            Image("umlRendererBackground")
                .resizable(resizingMode: .tile)
            
            Group {
                Canvas(renderer: umlRendererVM.render(_:size:))
                
                Canvas { context, size in
                    umlRendererVM.renderHighlights(&context, size: size)
                }
                .onTapGesture { tapLocation in
                    umlRendererVM.selectElement(at: tapLocation)
                }
            }
            .padding()
        }
        .onAppear {
            umlRendererVM.setup(modelString: modelString)
        }
    }
}

struct UMLRenderer_Previews: PreviewProvider {
    static var previews: some View {
        UMLRenderer(modelString:
                        (Submission.mockModeling.baseSubmission as? ModelingSubmission)?
            .getExercise(as: ModelingExercise.self)?.exampleSolutionModel ?? "nil")
            .padding()
    }
}
