//
//  UMLClassDiagramRelationshipRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 27.07.23.
//

import SwiftUI
import Common

struct UMLClassDiagramRelationshipRenderer: UMLDiagramRenderer {
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
        guard let xCoordinate = relationship.bounds?.x,
              let yCoordinate = relationship.bounds?.y,
              let width = relationship.bounds?.width,
              let height = relationship.bounds?.height else {
            log.warning("Failed to draw a UML relationship: \(relationship)")
            return
        }
        
        let relationshipRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)

        switch relationship.type {
        case .classDependency:
            drawDependency(relationship, in: relationshipRect)
        case .classAggregation, .classComposition:
            drawAggregationOrComposition(relationship, in: relationshipRect)
        case .classInheritance:
            drawInheritance(relationship, in: relationshipRect)
        case .classRealization:
            drawRealization(relationship, in: relationshipRect)
        case .classBidirectional:
            drawAssociation(relationship, in: relationshipRect)
        case .classUnidirectional:
            drawAssociation(relationship, in: relationshipRect)
        default:
            drawUnknown(relationship, in: relationshipRect)
        }
        
        drawMultiplicityText(relationship, in: relationshipRect)
        drawRoleText(relationship, in: relationshipRect)
    }
    
    private func drawDependency(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary), style: .init(dash: [7, 7]))
        drawArrowhead(for: relationship, on: path)
    }
    
    private func drawAggregationOrComposition(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary))
        drawArrowhead(for: relationship, on: path)
    }
    
    private func drawInheritance(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary))
        drawArrowhead(for: relationship, on: path)
    }
    
    private func drawRealization(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary), style: .init(dash: [7, 7]))
        drawArrowhead(for: relationship, on: path)
    }
    
    private func drawAssociation(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let path = getLinePath(for: relationship, in: relationshipRect) else {
            return
        }
        
        context.stroke(path, with: .color(Color.primary))
        drawArrowhead(for: relationship, on: path)
    }
    
    private func drawUnknown(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        drawAssociation(relationship, in: relationshipRect)
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
    
    private func drawArrowhead(for relationship: UMLRelationship, on path: Path) {
        guard let endPoint = path.currentPoint,
              let arrowTargetDirection = relationship.target?.direction else {
            log.warning("Could not draw arrowhead for: \(relationship)")
            return
        }
        
        var type: ArrowHeadType
        
        switch relationship.type {
        case .classBidirectional:
            return // bidirectional arrows have no heads
        case .classDependency, .classUnidirectional:
            type = .triangleWithoutBase
        case .classInheritance, .classRealization:
            type = .triangle
        case .classComposition:
            type = .rhombusFilled
        case .classAggregation:
            type = .rhombus
        default:
            type = .triangle
        }
        
        drawArrowhead(at: endPoint, lookingAt: arrowTargetDirection.inverted, type: type)
    }
    
    private func drawArrowhead(at point: CGPoint, lookingAt direction: Direction, type: ArrowHeadType) {
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
        case .rhombus, .rhombusFilled:
            path.move(to: .init(x: point.x, y: point.y))
            path.addLine(to: .init(x: point.x - size, y: point.y + size * 1.5))
            path.addLine(to: .init(x: point.x, y: point.y + size * 3))
            path.addLine(to: .init(x: point.x + size, y: point.y + size * 1.5))
            path.addLine(to: .init(x: point.x, y: point.y))
        }
                
        switch direction {
        case .up, .topLeft, .topRight:
            path = path.offsetBy(dx: 0, dy: size * 0.15)
        case .down, .downRight:
            path = path.rotation(.degrees(180)).path(in: path.boundingRect)
            if type == .rhombus || type == .rhombusFilled {
                path = path.offsetBy(dx: 0, dy: size * -3.1)
            } else {
                path = path.offsetBy(dx: 0, dy: size * -1.6)
            }
        case .right, .upRight, .bottomLeft:
            path = path.rotation(.degrees(90)).path(in: path.boundingRect)
            if type == .rhombus || type == .rhombusFilled {
                path = path.offsetBy(dx: size * -1.55, dy: size * -1.5)
            } else {
                path = path.offsetBy(dx: size * -0.8, dy: size * -0.75)
            }
        case .left, .upLeft, .downLeft, .bottomRight:
            path = path.rotation(.degrees(-90)).path(in: path.boundingRect)
            if type == .rhombus || type == .rhombusFilled {
                path = path.offsetBy(dx: size * 1.55, dy: size * -1.5)
            } else {
                path = path.offsetBy(dx: size * 0.8, dy: size * -0.75)
            }
        }
        
        context.stroke(path, with: .color(Color.primary))
        
        // Fill
        if type != .triangleWithoutBase {
            let fillColor = (type == .rhombusFilled) ? Color(UIColor.label) : Color(UIColor.systemBackground)
            context.fill(path, with: .color(fillColor))
        }
    }
    
    private func drawMultiplicityText(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let sourcePoint = relationship.path?.first?.asCGPoint,
              let sourceDirection = relationship.source?.direction?.inverted,
              let targetPoint = relationship.path?.last?.asCGPoint,
              let targetDirection = relationship.target?.direction?.inverted else {
            log.warning("Could not draw multiplicity text for: \(relationship)")
            return
        }
        
        var targetOffset: CGPoint
        let relativeSize = (fontSize * 0.7).rounded()
        
        switch relationship.type {
        case .classDependency, .classUnidirectional:
            targetOffset = .init(x: 10, y: 10)
        case .classInheritance, .classRealization:
            targetOffset = .init(x: 0, y: relativeSize * 1.5)
        case .classComposition, .classAggregation:
            targetOffset = .init(x: 0, y: relativeSize * 2)
        default:
            targetOffset = .zero
        }
        
        if let sourceMultiplicity = relationship.source?.multiplicity {
            drawMultiplicityText(sourceMultiplicity,
                                 at: sourcePoint,
                                 inParentRect: relationshipRect,
                                 direction: sourceDirection,
                                 offset: .zero)
        }
        
        if let targetMultiplicity = relationship.target?.multiplicity {
            drawMultiplicityText(targetMultiplicity,
                                 at: targetPoint,
                                 inParentRect: relationshipRect,
                                 direction: targetDirection,
                                 offset: targetOffset)
        }
    }
    
    /// Draws text representing the multiplicity value of a UML relationship
    /// - Parameters:
    ///   - text: multiplicity
    ///   - point: where to draw
    ///   - rect: parent rect of the relationship
    ///   - direction: where the arrowhead is looking at
    ///   - offset: to move the text in case the arrow head is too large (this is usually needed for aggregation and composition relationships)
    private func drawMultiplicityText(_ text: String,
                                      at point: CGPoint,
                                      inParentRect rect: CGRect,
                                      direction: Direction,
                                      offset: CGPoint) {
        let multiplicityText = Text(text).font(.system(size: fontSize))
        let resolvedText = context.resolve(multiplicityText)
        let textSize = resolvedText.measure(in: rect.size)
        
        var xPosition: CGFloat
        var yPosition: CGFloat
        
        switch direction {
        case .up, .topLeft, .topRight:
            xPosition = rect.minX + point.x + 7 + offset.x
            yPosition = rect.minY + point.y + 5 + offset.y
        case .down, .downLeft, .downRight:
            xPosition = rect.minX + point.x + 7 + offset.x
            yPosition = rect.minY + point.y - 20 - offset.y
        case .right, .upRight, .bottomRight:
            xPosition = rect.minX + point.x - 14 - offset.y
            yPosition = rect.minY + point.y + 5 + offset.x
        case .left, .upLeft, .bottomLeft:
            xPosition = rect.minX + point.x + 7 + offset.y
            yPosition = rect.minY + point.y + 5 + offset.x
        }
        
        let textRect = CGRect(x: xPosition, y: yPosition, width: textSize.width, height: textSize.height)
        
        context.draw(resolvedText, in: textRect)
    }
    
    private func drawRoleText(_ relationship: UMLRelationship, in relationshipRect: CGRect) {
        guard let sourcePoint = relationship.path?.first?.asCGPoint,
              let sourceDirection = relationship.source?.direction?.inverted,
              let targetPoint = relationship.path?.last?.asCGPoint,
              let targetDirection = relationship.target?.direction?.inverted else {
            log.warning("Could not draw role text for: \(relationship)")
            return
        }
        
        var targetOffset: CGPoint
        let relativeSize = (fontSize * 0.7).rounded()
        
        switch relationship.type {
        case .classDependency, .classUnidirectional:
            targetOffset = .init(x: 0, y: relativeSize * 1.5)
        case .classInheritance, .classRealization:
            targetOffset = .init(x: 0, y: relativeSize * 1.5)
        case .classComposition, .classAggregation:
            targetOffset = .init(x: 0, y: relativeSize * 2)
        default:
            targetOffset = .zero
        }
        
        if let sourceRole = relationship.source?.role {
            drawRoleText(sourceRole,
                         at: sourcePoint,
                         inParentRect: relationshipRect,
                         direction: sourceDirection,
                         offset: .zero)
        }
        
        if let targetRole = relationship.target?.role {
            drawRoleText(targetRole,
                         at: targetPoint,
                         inParentRect: relationshipRect,
                         direction: targetDirection,
                         offset: targetOffset)
        }
    }
    
    /// Draws text representing the role of an element in a UML relationship
    /// - Parameters:
    ///   - text: role
    ///   - point: where to draw
    ///   - rect: parent rect of the relationship
    ///   - direction: where the arrowhead is looking at
    ///   - offset: to move the text in case the arrow head is too large (this is usually needed for aggregation and composition relationships)
    private func drawRoleText(_ text: String,
                              at point: CGPoint,
                              inParentRect rect: CGRect,
                              direction: Direction,
                              offset: CGPoint) {
        let roleText = Text(text).font(.system(size: fontSize))
        let resolvedText = context.resolve(roleText)
        let textSize = resolvedText.measure(in: canvasBounds.size)
        
        var xPosition: CGFloat
        var yPosition: CGFloat
        
        switch direction {
        case .up, .topLeft, .topRight:
            xPosition = rect.minX + point.x - textSize.width - 7 - offset.x
            yPosition = rect.minY + point.y + 5 + offset.y
        case .down, .downLeft, .downRight:
            xPosition = rect.minX + point.x - textSize.width - 7 + offset.x
            yPosition = rect.minY + point.y - textSize.height - 5 - offset.y
        case .right, .upRight, .bottomRight:
            xPosition = rect.minX + point.x - textSize.width - offset.y
            yPosition = rect.minY + point.y - textSize.height - 5 + offset.x
        case .left, .upLeft, .bottomLeft:
            xPosition = rect.minX + point.x + 7 + offset.y
            yPosition = rect.minY + point.y - textSize.height - 5 + offset.x
        }
        
        let textRect = CGRect(x: xPosition, y: yPosition, width: textSize.width, height: textSize.height)
        
        context.draw(resolvedText, in: textRect)
    }
}

enum ArrowHeadType {
    case triangle, triangleWithoutBase, rhombus, rhombusFilled
}
