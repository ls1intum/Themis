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
    @ObservedObject var umlRendererVM: UMLRendererViewModel
    
    var body: some View {
        ZStack {
            Image("umlRendererBackground")
                .resizable(resizingMode: .tile)
            
            Group {
                Canvas(rendersAsynchronously: true) { context, size in
                    umlRendererVM.render(&context, size: size)
                }
                
                Canvas(rendersAsynchronously: true) { context, size in
                    umlRendererVM.renderHighlights(&context, size: size)
                } symbols: {
                    umlRendererVM.generatePossibleSymbols()
                }
                .onTapGesture { tapLocation in
                    umlRendererVM.selectItem(at: tapLocation)
                }
            }
            .padding()
        }
    }
}

struct UMLRenderer_Previews: PreviewProvider {
    static var umlRendererVM = UMLRendererViewModel()
    
    static var previews: some View {
        UMLRenderer(umlRendererVM: umlRendererVM)
            .onAppear {
                umlRendererVM.setup(basedOn: Submission.mockModeling.baseSubmission, AssessmentResult())
            }
            .padding()
    }
}
