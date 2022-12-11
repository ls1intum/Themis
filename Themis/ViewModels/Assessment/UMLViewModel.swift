//
//  UMLViewModel.swift
//  Themis
//
//  Created by Evan Christopher on 11.12.22.
//

import Foundation
import SwiftUI

class UMLViewModel: ObservableObject {
    @Published var imageURL: String?
    @Published var showUMLFullScreen: Bool = false
    @Published var viewOffset: CGSize = .zero
    @Published var bgOpacity: Double = 1
    @Published var scale: CGFloat = 1

    func onChange(value: CGSize) {
        // update offset
        viewOffset = value
        // calculate backgroun opacity
        let halgHeight = UIScreen.main.bounds.height / 2

        let progress = viewOffset.height / halgHeight

        withAnimation(.default) {
            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }

    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var translation = value.translation.height

            if translation < 0 {
                translation = -translation
            }

            if translation < 250 {
                viewOffset = .zero
                bgOpacity = 1
            } else {
                showUMLFullScreen.toggle()
                viewOffset = .zero
                bgOpacity = 1
            }
        }
    }
}
