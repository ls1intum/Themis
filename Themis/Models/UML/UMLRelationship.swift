//
//  UMLRelationship.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//
// swiftlint:disable discouraged_optional_boolean

import Foundation
import SwiftUI

struct UMLRelationship: Decodable {
    let id: String?
    let name: String?
    let type: UMLRelationshipType?
    let owner: String?
    let bounds: Boundary?
    let assessmentNote: String?
    let path: [PathPoint]?
    let source: UMLRelationshipEndPoint?
    let target: UMLRelationshipEndPoint?
    let isManuallyLayouted: Bool?
}

struct PathPoint: Decodable {
    // swiftlint:disable identifier_name
    let x: Double
    let y: Double
    
    var asCGPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}

struct UMLRelationshipEndPoint: Decodable {
    /// The id of the UML element that the endpoint is attached to
    let element: String?
    /// Indicates the side, from which the endpoint is attached to the UML element
    let direction: Direction?
}

enum Direction: String, Decodable {
    case left = "Left"
    case right = "Right"
    case up = "Up"
    case down = "Down"
    
    var inverted: Self {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .down:
            return .up
        case .up:
            return .down
        }
    }
}
// swiftlint:enable identifier_name
// swiftlint:enable discouraged_optional_boolean
