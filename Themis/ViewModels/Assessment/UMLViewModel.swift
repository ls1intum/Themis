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
    @Published var showUMLFullScreen = false
    @Published var scale: CGFloat = 1
}
