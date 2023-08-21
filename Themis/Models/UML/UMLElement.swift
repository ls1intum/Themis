//
//  UMLElement.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//

import SwiftUI

// Note: this is not a struct because we need references to handle parent-child relationship between elements
class UMLElement: Decodable, SelectableUMLItem {
    let id: String?
    let name: String?
    let type: UMLElementType?
    let owner: String?
    let bounds: Boundary?
    let assessmentNote: String?
    
    var children: [UMLElement]? = [] // not decoded
    
    /// Childresn of this element sorted by their vertical position (top to bottom)
    var verticallySortedChildren: [UMLElement]? {
        children?.sorted(by: { ($0.bounds?.y ?? 0.0) < ($1.bounds?.y ?? 0.0) })
    }
    
    var typeAsString: String? {
        type?.rawValue
    }
    
    var highlightPath: Path? {
        guard let boundsAsCGRect else {
            return nil
        }
        
        return Path(boundsAsCGRect.insetBy(dx: -1, dy: -1))
    }
    
    lazy var badgeLocation: CGPoint? = {
        guard let boundsAsCGRect else {
            return nil
        }
        
        return CGPoint(x: boundsAsCGRect.maxX, y: boundsAsCGRect.minY)
    }()
    
    /// Recursively looks for the child UML element located at the given point
    func getChild(at point: CGPoint) -> UMLElement? {
        guard let children else {
            return nil
        }
        
        for child in children where child.boundsContains(point: point) {
            return child.getChild(at: point) ?? child
        }
        
        return nil
    }
    
    func addChild(_ child: UMLElement) {
        if children == nil {
            self.children = [child]
        } else {
            self.children?.append(child)
        }
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

struct Boundary: Decodable {
    // swiftlint:disable identifier_name
    let x: Double
    let y: Double
    let width: Double
    let height: Double
    // swiftlint:enable identifier_name
}
