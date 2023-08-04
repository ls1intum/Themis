//
//  UMLGraphicsContext.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.08.23.
//

import SwiftUI

/// A wrapper for `GraphicsContext` to customize some of its behavior
struct UMLGraphicsContext {
    var baseGraphicsContext: GraphicsContext
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    static var defaultOffset: CGFloat = 15
    
    init(_ context: GraphicsContext,
         xOffset: CGFloat = defaultOffset,
         yOffset: CGFloat = defaultOffset) {
        self.baseGraphicsContext = context
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
    
    // MARK: - Fill
    func fill(_ path: Path, with shading: GraphicsContext.Shading, style: FillStyle = FillStyle()) {
        let pathWithOffset = path.offsetBy(dx: xOffset, dy: yOffset)
        baseGraphicsContext.fill(pathWithOffset, with: shading, style: style)
    }
    
    // MARK: - Stroke
    func stroke(_ path: Path, with shading: GraphicsContext.Shading, lineWidth: CGFloat = 1) {
        let pathWithOffset = path.offsetBy(dx: xOffset, dy: yOffset)
        baseGraphicsContext.stroke(pathWithOffset, with: shading, lineWidth: lineWidth)
    }
    
    func stroke(_ path: Path, with shading: GraphicsContext.Shading, style: StrokeStyle) {
        let pathWithOffset = path.offsetBy(dx: xOffset, dy: yOffset)
        baseGraphicsContext.stroke(pathWithOffset, with: shading, style: style)
    }
    
    
    // MARK: - Draw
    func draw(_ text: GraphicsContext.ResolvedText, in rect: CGRect) {
        let rectWithOffset = rect.offsetBy(dx: xOffset, dy: yOffset)
        baseGraphicsContext.draw(text, in: rectWithOffset)
    }
    
    func draw(_ symbol: GraphicsContext.ResolvedSymbol, in rect: CGRect) {
        let rectWithOffset = rect.offsetBy(dx: xOffset, dy: yOffset)
        baseGraphicsContext.draw(symbol, in: rectWithOffset)
    }
    
    func draw(_ image: GraphicsContext.ResolvedImage, in rect: CGRect, style: FillStyle = FillStyle()) {
        let rectWithOffset = rect.offsetBy(dx: xOffset, dy: yOffset)
        baseGraphicsContext.draw(image, in: rectWithOffset, style: style)
    }
    
    func draw(_ image: GraphicsContext.ResolvedImage, at point: CGPoint, anchor: UnitPoint = .center) {
        let pointWithOffset = CGPoint(x: point.x + xOffset, y: point.y + yOffset)
        baseGraphicsContext.draw(image, at: pointWithOffset, anchor: anchor)
    }
    
    // MARK: - Resolve
    func resolve(_ text: Text) -> GraphicsContext.ResolvedText {
        baseGraphicsContext.resolve(text)
    }
    
    func resolveSymbol<ID>(id: ID) -> GraphicsContext.ResolvedSymbol? where ID : Hashable {
        baseGraphicsContext.resolveSymbol(id: id)
    }
}
