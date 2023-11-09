//
//  PaneViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

class PaneViewModel: ObservableObject {
    @Published var dragWidthLeft: CGFloat = 0.2 * UIScreen.main.bounds.size.width
    @Published var dragWidthRight: CGFloat = 0
    @Published var showLeftPane = true
    @Published var leftPaneAsPlaceholder = false
    @Published var showRightPane = false
    @Published var rightPaneAsPlaceholder = true
    
    let maxRightWidth: CGFloat
    let minRightWidth: CGFloat
    let minRightSnapWidth: CGFloat
    let minLeftSnapWidth: CGFloat = 150
    
    init(mode: PaneMode = .threePanes) {
        maxRightWidth = (0.5 * UIScreen.main.bounds.size.width).rounded()
        
        switch mode {
        case .threePanes:
            // default values mostly cover this case
            minRightWidth = 0
            minRightSnapWidth = 185
        case .rightOnly:
            showLeftPane = false
            leftPaneAsPlaceholder = true
            rightPaneAsPlaceholder = false
            showRightPane = true
            minRightWidth = (0.2 * UIScreen.main.bounds.size.width).rounded()
            dragWidthRight = (0.25 * UIScreen.main.bounds.size.width).rounded()
            minRightSnapWidth = 0
        }
    }
    
    func handleLeftGripDrag(_ gesture: DragGesture.Value) {
        let maxLeftWidth: CGFloat = 0.4 * UIScreen.main.bounds.size.width
        let delta = gesture.translation.width
        
        dragWidthLeft += delta
        
        if dragWidthLeft > maxLeftWidth {
            dragWidthLeft = maxLeftWidth
        } else if dragWidthLeft < 0 {
            dragWidthLeft = 0
        }
        
        leftPaneAsPlaceholder = dragWidthLeft < minLeftSnapWidth ? true : false
    }
    
    func handleLeftGripDragEnd(_ gesture: DragGesture.Value) {
        if dragWidthLeft < minLeftSnapWidth {
            dragWidthLeft = 0.2 * UIScreen.main.bounds.size.width
            showLeftPane = false
            leftPaneAsPlaceholder = false
        }
    }
    
    func handleRightGripDrag(_ gesture: DragGesture.Value) {
        let delta = gesture.translation.width
        
        dragWidthRight -= delta
        dragWidthRight.round()
        
        if dragWidthRight > maxRightWidth {
            dragWidthRight = maxRightWidth
        } else if dragWidthRight < minRightWidth {
            dragWidthRight = minRightWidth
        }
        
        rightPaneAsPlaceholder = dragWidthRight < minRightSnapWidth ? true : false
    }
    
    func handleRightGripDragEnd(_ gesture: DragGesture.Value) {
        if dragWidthRight < minRightSnapWidth {
            showRightPane = false
            dragWidthRight = 0
        } else {
            showRightPane = true
        }
    }
    
    func handleRightGripTap() {
        if dragWidthRight <= 0 {
            withAnimation {
                showRightPane = true
                dragWidthRight = 250
                rightPaneAsPlaceholder = false
            }
        }
    }
}

enum PaneMode {
    case threePanes, rightOnly
}
