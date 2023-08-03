//
//  UMLRelationship.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//
// swiftlint:disable discouraged_optional_boolean

import Foundation
import SwiftUI

struct UMLRelationship: Decodable, SelectableUMLItem {
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
    
    var typeAsString: String? {
        type?.rawValue
    }
    
    /// Contains rectangles drawn between PathPoints
    private var pathRects: [CGRect] {
        guard let path,
              let boundsX = bounds?.x,
              let boundsY = bounds?.y,
              let boundsAsCGRect else {
            return []
        }
        
        var result = [CGRect]()
        
        // Iterate through points and create CGRects between them
        for index in 0..<path.count where index != path.count - 1 {
            let pointA = path[index].asCGPoint
            let pointB = path[index + 1].asCGPoint
            
            var rectPath = Path()
            rectPath.addLines([pointA, pointB])
            
            let pathRect = rectPath.boundingRect.insetBy(dx: -15, dy: -15)
            let pathRectWithOffset = pathRect.offsetBy(dx: boundsX, dy: boundsY)
            
            result.append(pathRectWithOffset.intersection(boundsAsCGRect))
        }

        return result
    }
    
    var highlightPath: Path? {
        var result = Path()
        result.addRects(pathRects)
        return result
    }
    
    var temporaryHighlightPath: Path? {
        guard let path, let boundsAsCGRect else {
            return nil
        }
        var result = Path()
        result.addLines(path.map({ $0.asCGPoint.applying(.init(translationX: boundsAsCGRect.minX, y: boundsAsCGRect.minY)) }))
        return result
    }
    
    var badgeLocation: CGPoint? {
        guard let path, let boundsAsCGRect else {
            return nil
        }
        
        // The idea is to find the mid point if the number of points is odd.
        // If the number of points is even, then the number of pathRects between them is going to be odd. This means we can find the mid CGRect and take it's mid point to place the badge.
        
        if !path.count.isMultiple(of: 2) { // odd point count
            return path[path.count / 2].asCGPoint.applying(.init(translationX: boundsAsCGRect.minX,
                                                                 y: boundsAsCGRect.minY)) // mid point
        } else if !pathRects.count.isMultiple(of: 2) { // odd rect count
            let midRect = pathRects[pathRects.count / 2]
            return CGPoint(x: midRect.midX, y: midRect.midY) // mid point
        }
        
        return nil
    }
    
    var pathWithCGPoints: Path? {
        guard let boundsAsCGRect,
              let selfPath = self.path,
              selfPath.count >= 2 else {
            return nil
        }
        
        let points = selfPath.map {
            $0.asCGPoint.applying(.init(translationX: boundsAsCGRect.minX,
                                        y: boundsAsCGRect.minY))
        }
        
        var path = Path()
        path.addLines(Array(points))
        
        return path
    }
    
    func boundsContains(point: CGPoint) -> Bool {
        pathRects.contains(where: { $0.contains(point) })
    }
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
    let multiplicity: String?
    let role: String?
}

enum Direction: String, Decodable {
    case left = "Left"
    case right = "Right"
    case up = "Up"
    case down = "Down"
    case upRight = "Upright"
    case upLeft = "Upleft"
    case downRight = "Downright"
    case downLeft = "Downleft"
    case topRight = "Topright"
    case topLeft = "Topleft"
    case bottomRight = "Bottomright"
    case bottomLeft = "Bottomleft"
    
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
        case .upRight:
            return .upLeft
        case .upLeft:
            return .upRight
        case .downRight:
            return .downLeft
        case .downLeft:
            return .downRight
        case .topRight:
            return .bottomRight
        case .topLeft:
            return .bottomLeft
        case .bottomRight:
            return .topRight
        case .bottomLeft:
            return .topLeft
        }
    }
}
// swiftlint:enable identifier_name
// swiftlint:enable discouraged_optional_boolean
