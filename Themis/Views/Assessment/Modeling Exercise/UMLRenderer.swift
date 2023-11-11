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
    
    @State var showResetButton = true
    @State var scale: CGFloat = 1
    
    @State private var progressingScale: CGFloat = 1
    @State private var startDragLocation = CGPoint.zero
    @State private var dragStarted = true
    
    /// The minimum scale value that the UML model can be scaled down to
    private let minScale = 0.1
    
    var body: some View {
        ZStack(alignment: .topLeading) {
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
            .frame(minWidth: umlRendererVM.diagramSize.width,
                   minHeight: umlRendererVM.diagramSize.height)
            .padding()
            .scaleEffect(scale * progressingScale)
            .position(umlRendererVM.currentDragLocation)
            
            resetZoomAndLocationButton
        }
        .onChange(of: umlRendererVM.diagramSize) {
            umlRendererVM.setDragLocation()
        }
        .gesture(
            DragGesture()
                .onChanged(handleDrag)
                .onEnded { _ in
                    dragStarted = true
                }
        )
        .simultaneousGesture(
            MagnificationGesture()
                .onChanged(handleMagnification)
                .onEnded(handleMagnificationEnd)
        )
    }
    
    @ViewBuilder
    private var resetZoomAndLocationButton: some View {
        if showResetButton {
            Button {
                umlRendererVM.setDragLocation()
                scale = 1
                progressingScale = 1
            } label: {
                Image(systemName: "scope")
                    .frame(alignment: .topLeading)
                    .foregroundColor(.white)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.themisSecondary)
                    }
            }
            .padding(12)
        }
    }
    
    private func handleDrag(_ gesture: DragGesture.Value) {
        if dragStarted {
            dragStarted = false
            startDragLocation = umlRendererVM.currentDragLocation
        }
        umlRendererVM.setDragLocation(at: CGPoint(x: startDragLocation.x + gesture.translation.width,
                                                  y: startDragLocation.y + gesture.translation.height))
    }
    
    private func handleMagnification(_ newScale: MagnificationGesture.Value) {
        progressingScale = newScale
        
        // Enforce zoom out limit
        if progressingScale * scale < minScale {
            progressingScale = minScale / scale
        }
    }
    
    private func handleMagnificationEnd(_ finalScale: MagnificationGesture.Value) {
        scale *= finalScale
        progressingScale = 1
        
        // Enforce zoom out limit
        if scale < minScale {
            scale = minScale
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
