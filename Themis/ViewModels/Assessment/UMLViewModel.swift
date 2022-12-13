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
    @Published var scale: CGFloat = 1

    func calculateOpacity(value: CGSize) -> Double {
        // calculate background opacity based on offset
        return Double(1 - abs(value.height / (UIScreen.main.bounds.height / 2)))
    }
}
