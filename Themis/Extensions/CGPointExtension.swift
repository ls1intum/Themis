//
//  CGPointExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.08.23.
//

import Foundation

extension CGPoint {
    /// Returns the angle relative to the comparison point
    /// Inspired from: https://stackoverflow.com/a/33158630/7074664
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - x
        let originY = comparisonPoint.y - y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = (bearingRadians * 180) / Float.pi - 90
        
        while bearingDegrees >= 360 { bearingDegrees -= 360 }
        while bearingDegrees < 0 { bearingDegrees += 360 }
        
        return CGFloat(bearingDegrees * -1)
    }
    
    func rotated(around center: CGPoint, angleInDegrees angle: CGFloat) -> CGPoint {
        let angleInRadians = angle * CGFloat.pi / 180.0
        let translatedPoint = CGPoint(x: self.x - center.x, y: self.y - center.y)
        let rotatedX = translatedPoint.x * cos(angleInRadians) - translatedPoint.y * sin(angleInRadians)
        let rotatedY = translatedPoint.x * sin(angleInRadians) + translatedPoint.y * cos(angleInRadians)
        return CGPoint(x: rotatedX + center.x, y: rotatedY + center.y)
    }
    
    func invertY() -> CGPoint {
        Self(x: self.x, y: -self.y)
    }
}
