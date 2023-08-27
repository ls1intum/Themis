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
    /// The path that should be highlighted when this element is selected
    var highlightPath: Path? { get }
    /// The path that should be highlighted when the corresponding feedback cell is tapped
    var temporaryHighlightPath: Path? { get }
    /// The point where this UML item prefers to have it's badge. Badges are used to indicate a feedback referencing this item
    var badgeLocation: CGPoint? { get }
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
    
    var temporaryHighlightPath: Path? {
        highlightPath
    }
}
