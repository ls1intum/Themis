//
//  UMLElement.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//

import Foundation

protocol SelectableUMLItem {
    var id: String? { get }
    var name: String? { get }
    var owner: String? { get }
    var bounds: Boundary? { get }
}

// Note: this is not a struct because we need references to handle parent-child relationship between elements
class UMLElement: Decodable, SelectableUMLItem {
    let id: String?
    let name: String?
    let type: UMLElementType?
    let owner: String?
    let bounds: Boundary?
    let assessmentNote: String?
    
    var children: [UMLElement]? = [] // not decoded
    
    /// Return true if the given point lies within the boundary of this element
    func boundsContains(point: CGPoint) -> Bool {
        guard let bounds else {
            return false
        }
        
        let isXWithinBounds = point.x > bounds.x && point.x < (bounds.x + bounds.width)
        let isYWithinBounds = point.y > bounds.y && point.y < (bounds.y + bounds.height)
        
        return isXWithinBounds && isYWithinBounds
    }
    
    /// Recursively looks for the child UML element located at the given point
    func getChild(at point: CGPoint) -> UMLElement? {
        guard let children else {
            return nil
        }
        
        for child in children {
            if child.boundsContains(point: point) {
                return child.getChild(at: point) ?? child
            }
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
}

struct Boundary: Decodable {
    // swiftlint:disable identifier_name
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}
