//
//  Line.swift
//  DrawingApp
//
//  Created by Karin Prater + Tom + Paul on 18.06.21.
//

import Foundation
import SwiftUI

public struct Line: Identifiable {

    public var points: [CGPoint]
    public var color: Color
    public var lineWidth: CGFloat

    public let id = UUID()

    public init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.points = points
        self.color = color
        self.lineWidth = lineWidth
    }
}
