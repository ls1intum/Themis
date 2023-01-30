//
//  ShakeEffect.swift
//  Themis
//
//  Created by Evan Christopher on 30.01.23.
//

import Foundation
import SwiftUI

struct ShakeEffect: GeometryEffect {
    var position: CGFloat = 10
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    init(animatableData: CGFloat) {
       position = animatableData
   }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: -5 * sin(position * 2 * .pi), y: 0))
    }
}
