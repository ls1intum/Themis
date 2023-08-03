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
    
    @State private var location = CGPoint(x: 30, y: 30)
    @State private var startDragLocation = CGPoint.zero
    @State private var dragStarted = true
    
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
            .position(location)
        }
        .onChange(of: umlRendererVM.diagramSize, perform: { newValue in
            location = .init(x: newValue.height, y: newValue.width)
        })
        .frame(minWidth: umlRendererVM.diagramSize.width * 1.1,
               minHeight: umlRendererVM.diagramSize.height * 1.1, alignment: .center)
        .gesture(
            DragGesture()
                .onChanged(handleDrag)
                .onEnded { _ in
                    dragStarted = true
                }
        )
    }
    
    private func handleDrag(_ gesture: DragGesture.Value) {
        if dragStarted {
            dragStarted = false
            startDragLocation = location
        }
        location = CGPoint(x: startDragLocation.x + gesture.translation.width,
                           y: startDragLocation.y + gesture.translation.height)
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
