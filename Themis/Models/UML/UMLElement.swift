//
//  UMLElement.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//

import Foundation

// Note: this is not a struct because we need references to handle parent-child relationship between elements
class UMLElement: Decodable, SelectableUMLItem {
    let id: String?
    let name: String?
    let type: UMLElementType?
    let owner: String?
    let bounds: Boundary?
    let assessmentNote: String?
    
    var children: [UMLElement]? = [] // not decoded
    var typeAsString: String? {
        type?.rawValue
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
