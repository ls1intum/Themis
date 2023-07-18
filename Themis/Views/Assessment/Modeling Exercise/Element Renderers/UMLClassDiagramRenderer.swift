//
//  UMLClassDiagramRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.07.23.
//

import SwiftUI
import Common
import SharedModels

protocol UMLDiagramRenderer {
    func render(umlModel: UMLModel)
}

struct UMLClassDiagramRenderer: UMLDiagramRenderer {
    var context: GraphicsContext
    let canvasBounds: CGRect
    
    private let fontSize: CGFloat = 14

    func render(umlModel: UMLModel) {
        let elementRenderer = UMLClassDiagramElementRenderer(context: context, canvasBounds: canvasBounds)
        let relationshipRenderer = UMLClassDiagramRelationshipRenderer(context: context, canvasBounds: canvasBounds)
        
        elementRenderer.render(umlModel: umlModel)
        relationshipRenderer.render(umlModel: umlModel)
    }
}

// MARK: - Element Renderer
private struct UMLClassDiagramElementRenderer: UMLDiagramRenderer {
    var context: GraphicsContext
    let canvasBounds: CGRect
    
    private let fontSize: CGFloat = 14
    
    func render(umlModel: UMLModel) {
        guard let elements = umlModel.elements else {
            log.error("The UML model contains no elements")
            return
        }
        
        for element in elements {
            draw(element: element)
        }
    }
    
    private func draw(element: UMLElement) {
        guard let xCoordinate = element.bounds?.x,
           let yCoordinate = element.bounds?.y,
           let width = element.bounds?.width,
           let height = element.bounds?.height else {
            log.warning("Failed to draw a UML element: \(element)")
            return
        }
        
        let elementRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        
        switch element.type {
        case .Class, .abstractClass, .classMethod, .classAttribute, .enumeration, .interface:
            drawClassLikeElement(element: element, elementRect: elementRect)
        case .package:
            drawPackage(element: element, elementRect: elementRect)
        default:
            drawUnknownElement(element: element, elementRect: elementRect)
        }
    }
    
    private func drawClassLikeElement(element: UMLElement, elementRect: CGRect) {
        context.fill(Path(elementRect), with: .color(Color(UIColor.systemBackground)))
        context.stroke(Path(elementRect), with: .color(Color.primary))
        
        switch element.type {
        case .classAttribute, .classMethod:
            drawAttributeOrMethod(element, in: elementRect)
        default:
            drawTitle(of: element, in: elementRect)
        }
    }
    
    private func drawPackage(element: UMLElement, elementRect: CGRect) {
        
        let topCornerRect = CGRect(x: elementRect.minX,
                                   y: elementRect.minY,
                                   width: 45,
                                   height: 10)
        context.fill(Path(topCornerRect), with: .color(Color(UIColor.systemBackground)))
        context.stroke(Path(topCornerRect), with: .color(Color.primary))
        
        let newElementRect = CGRect(x: elementRect.minX,
                                    y: elementRect.minY + topCornerRect.height,
                                    width: elementRect.width,
                                    height: elementRect.height - topCornerRect.height)
        
        context.fill(Path(newElementRect), with: .color(Color(UIColor.systemBackground)))
        context.stroke(Path(newElementRect), with: .color(Color.primary))
        drawTitle(of: element, in: newElementRect)
    }
    
    private func drawUnknownElement(element: UMLElement, elementRect: CGRect) {
        log.warning("Drawing logic for elements of type \(element.type?.rawValue ?? "nil") is not implemented")
        context.stroke(Path(elementRect), with: .color(Color.secondary))
    }
    
    private func drawTitle(of element: UMLElement, in elementRect: CGRect) {
        var titleY: CGFloat
        
        // START: Draw type text
        let typeTextString = element.type?.annotationTitle ?? ""
        var typeText = Text(typeTextString)
        typeText = typeText.font(.system(size: fontSize * 0.7, weight: .bold).monospaced())
        let typeResolved = context.resolve(typeText)
        let typeTextSize = typeResolved.measure(in: elementRect.size)
        
        let typeRect = CGRect(x: elementRect.midX - typeTextSize.width / 2,
                              y: elementRect.minY + 5,
                              width: typeTextSize.width,
                              height: typeTextSize.height)
        context.draw(typeResolved, in: typeRect)
        // END: Draw type text
        
        titleY = typeTextString.isEmpty ? elementRect.minY + 5 : typeRect.maxY
        
        // START: Draw title text
        var text = Text(element.name ?? "")
        text = text.font(.system(size: fontSize, weight: .bold))
        
        let elementTitle = context.resolve(text)
        let titleSize = elementTitle.measure(in: elementRect.size)
        let titleRect = CGRect(x: elementRect.midX - titleSize.width / 2,
                               y: titleY,
                               width: titleSize.width,
                               height: titleSize.height)
        
        context.draw(elementTitle, in: titleRect)
        // END: Draw title text
    }
    
    private func drawAttributeOrMethod(_ element: UMLElement, in elementRect: CGRect) {
        var text = Text(element.name ?? "")
        text = text.font(.system(size: fontSize))

        let elementTitle = context.resolve(text)
        let titleSize = elementTitle.measure(in: elementRect.size)
        let titleRect = CGRect(x: elementRect.minX + 5,
                               y: elementRect.midY - titleSize.height / 2,
                               width: titleSize.width,
                               height: titleSize.height)
        
        context.draw(elementTitle, in: titleRect)
    }
}

// MARK: - Relationship Renderer
private struct UMLClassDiagramRelationshipRenderer: UMLDiagramRenderer {
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
        let size: CGFloat = 10
        
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
        case .up:
            path = path.offsetBy(dx: 0, dy: size * 0.15)
        case .down:
            path = path.rotation(.degrees(180)).path(in: path.boundingRect)
            if type == .rhombus || type == .rhombusFilled {
                path = path.offsetBy(dx: 0, dy: size * -3.1)
            } else {
                path = path.offsetBy(dx: 0, dy: size * -1.6)
            }
        case .right:
            path = path.rotation(.degrees(90)).path(in: path.boundingRect)
            if type == .rhombus || type == .rhombusFilled {
                path = path.offsetBy(dx: size * -1.55, dy: size * -1.5)
            } else {
                path = path.offsetBy(dx: size * -0.8, dy: size * -0.75)
            }
        case .left:
            path = path.rotation(.degrees(-90)).path(in: path.boundingRect)
            if type == .rhombus || type == .rhombusFilled {
                path = path.offsetBy(dx: size * 1.55, dy: size * -1.5)
            } else {
                path = path.offsetBy(dx: size * 0.7, dy: size * 0.3)
            }
        }
        
        context.stroke(path, with: .color(Color.primary))
        
        // Fill
        if type != .triangleWithoutBase {
            if type == .rhombusFilled {
                context.fill(path, with: .color(Color(UIColor.label)))
            } else {
                context.fill(path, with: .color(Color(UIColor.systemBackground)))
            }
        }
    }
}

enum ArrowHeadType {
    case triangle, triangleWithoutBase, rhombus, rhombusFilled
}
