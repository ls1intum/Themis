//
//  SelectableUMLItem.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 25.07.23.
//

import SwiftUI

/// Represents any UML item (element, relationship, etc.) that can be selected by the user to add a referenced feedback
protocol SelectableUMLItem {
    var id: String? { get }
    var name: String? { get }
    var owner: String? { get }
    var bounds: Boundary? { get }
    var highlightPath: Path? { get }
    var boundsAsCGRect: CGRect? { get }
    var typeAsString: String? { get }
    
    /// Return true if the given point lies within the boundary of this element
    func boundsContains(point: CGPoint) -> Bool
}

extension SelectableUMLItem { // default implementations for all conforming types
    var boundsAsCGRect: CGRect? {
        guard let xCoordinate = bounds?.x,
              let yCoordinate = bounds?.y,
              let width = bounds?.width,
              let height = bounds?.height else {
            return nil
        }
        return CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
    }
    
    var highlightPath: Path? {
        guard let boundsAsCGRect else {
            return nil
        }
        
        return Path(boundsAsCGRect.insetBy(dx: -1, dy: -1))
    }
    
    func boundsContains(point: CGPoint) -> Bool {
        guard let bounds else {
            return false
        }
        
        let isXWithinBounds = point.x > bounds.x && point.x < (bounds.x + bounds.width)
        let isYWithinBounds = point.y > bounds.y && point.y < (bounds.y + bounds.height)
        
        return isXWithinBounds && isYWithinBounds
    }
}
