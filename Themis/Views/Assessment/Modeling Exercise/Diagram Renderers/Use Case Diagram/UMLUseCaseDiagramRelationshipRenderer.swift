//
//  UMLUseCaseDiagramRelationshipRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.08.23.
//

import SwiftUI
import Common

struct UMLUseCaseDiagramRelationshipRenderer: UMLDiagramRenderer {
    var context: GraphicsContext
    let canvasBounds: CGRect
    
    private let fontSize: CGFloat = 14
    
    func render(umlModel: UMLModel) {
        guard let relationships = umlModel.relationships else {
            log.warning("The UML model contains no relationships")
            return
        }
        
        for relationship in relationships {
            draw(relationship: relationship)
        }
    }
    
    private func draw(relationship: UMLRelationship) {
        guard let relationshipRect = relationship.boundsAsCGRect else {
            log.warning("Failed to draw a UML relationship: \(relationship)")
            return
        }
        
        switch relationship.type {
        case .useCaseAssociation:
            drawAssociation(relationship, in: relationshipRect)
        case .useCaseExtend, .useCaseInclude:
            drawExtendOrInclude(relationship, in: relationshipRect)
        case .useCaseGeneralization:
            drawGeneralization(relationship, in: relationshipRect)
        default:
            drawUnknown(relationship, in: relationshipRect)
        }
        
        //        drawRoleText(relationship, in: relationshipRect)
    }
    
    private func drawAssociation(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary))
    }
    
    private func drawExtendOrInclude(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary), style: .init(dash: [7, 7]))
        drawArrowhead(for: relationship, on: path)
        // TODO: add <<extend>> and <<include>> texts
    }
    
    private func drawGeneralization(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary))
        drawArrowhead(for: relationship, on: path)
    }
    
    private func drawUnknown(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        drawAssociation(relationship, in: relationshipRect)
    }
    
    private func drawArrowhead(for relationship: UMLRelationship, on path: Path) {
        guard let relationshipRect = relationship.boundsAsCGRect,
              let endPoint = path.currentPoint,
              let pointCount = relationship.path?.count,
              let previousPoint = relationship.path?[pointCount - 2].asCGPoint else {
            log.warning("Could not draw arrowhead for: \(relationship)")
            return
        }
        
        var type: ArrowHeadType
        
        switch relationship.type {
        case .useCaseInclude, .useCaseExtend:
            type = .triangleWithoutBase
        case .useCaseGeneralization:
            type = .triangle
        default:
            return
        }
        
        var previousPointInverted = previousPoint.applying(.init(translationX: relationshipRect.minX,
                                                                 y: relationshipRect.minY))
        previousPointInverted.y *= -1
        
        var endPointInverted = endPoint
        endPointInverted.y *= -1
        
        let rotationDegrees = previousPointInverted.angle(to: endPointInverted)
        drawArrowhead(at: endPoint, rotatedBy: .degrees(rotationDegrees), type: type)
    }
    
    private func drawArrowhead(at point: CGPoint, rotatedBy angle: Angle, type: ArrowHeadType) {
        var path = Path()
        let size: CGFloat = (fontSize * 0.7).rounded()
                
        switch type {
        case .triangle:
            path.move(to: .init(x: point.x, y: point.y))
            path.addLine(to: .init(x: point.x - size, y: point.y + size * 1.5))
            path.addLine(to: .init(x: point.x + size, y: point.y + size * 1.5))
            path.addLine(to: .init(x: point.x, y: point.y))
        case .triangleWithoutBase:
            path.move(to: .init(x: point.x - size, y: point.y + size * 1.5))
            path.addLine(to: .init(x: point.x, y: point.y))
            path.addLine(to: .init(x: point.x + size, y: point.y + size * 1.5))
        default:
            path.move(to: .init(x: point.x, y: point.y))
        }
        
        path = path.rotation(angle, anchor: .top).path(in: path.boundingRect)
        
        context.stroke(path, with: .color(Color.primary))
        
        // Fill
        if type != .triangleWithoutBase {
            let fillColor = (type == .rhombusFilled) ? Color(UIColor.label) : Color(UIColor.systemBackground)
            context.fill(path, with: .color(fillColor))
        }
    }
    
    private func getLinePath(for relationship: UMLRelationship, in relationshipRect: CGRect) -> Path? {
        guard let relationshipPath = relationship.path,
              relationshipPath.count >= 2 else {
            return nil
        }
        
        let points = relationshipPath.map { $0.asCGPoint.applying(.init(translationX: relationshipRect.minX, y: relationshipRect.minY)) }
        
        var path = Path()
        path.addLines(Array(points))
        
        return path
    }
}

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
}
