//
//  UMLUseCaseDiagramElementRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.08.23.
//

import SwiftUI
import Common

struct UMLUseCaseDiagramElementRenderer: UMLDiagramRenderer {
    var context: UMLGraphicsContext
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
        guard let elementRect = element.boundsAsCGRect else {
            log.warning("Failed to draw a UML element: \(element)")
            return
        }
                
        switch element.type {
        case .useCaseSystem:
            drawSystem(element: element, elementRect: elementRect)
        case .useCaseActor:
            drawActor(element: element, elementRect: elementRect)
        case .useCase:
            drawUseCase(element: element, elementRect: elementRect)
        default:
            drawUnknownElement(element: element, elementRect: elementRect)
        }
    }
    
    private func drawSystem(element: UMLElement, elementRect: CGRect) {
        context.fill(Path(elementRect), with: .color(Color(UIColor.systemBackground)))
        context.stroke(Path(elementRect), with: .color(Color.primary))
        drawTitle(of: element, in: elementRect)
    }
    
    private func drawActor(element: UMLElement, elementRect: CGRect) {
        let headDiameter = elementRect.width / 2
        let headPath = Path(ellipseIn: .init(x: elementRect.midX - headDiameter / 2,
                                             y: elementRect.minY,
                                             width: headDiameter,
                                             height: headDiameter))
        context.fill(headPath, with: .color(Color(UIColor.systemBackground)))
        context.stroke(headPath, with: .color(Color.primary))
        
        var bodyPath = Path()
        bodyPath.move(to: .init(x: headPath.boundingRect.midX,
                                y: headPath.boundingRect.maxY))
        bodyPath.addLine(to: .init(x: headPath.boundingRect.midX,
                                   y: headPath.boundingRect.maxY + elementRect.height * 0.45))
        context.stroke(bodyPath, with: .color(Color.primary))
        
        var armPath = Path()
        armPath.move(to: .init(x: elementRect.minX,
                               y: headPath.boundingRect.maxY * 1.03))
        armPath.addLine(to: .init(x: elementRect.maxX,
                                  y: headPath.boundingRect.maxY * 1.03))
        context.stroke(armPath, with: .color(Color.primary))
        
        var legPath = Path()
        legPath.move(to: bodyPath.currentPoint ?? .zero)
        legPath.addLine(to: .init(x: elementRect.minX,
                                  y: elementRect.maxY))
        legPath.move(to: bodyPath.currentPoint ?? .zero)
        legPath.addLine(to: .init(x: elementRect.maxX,
                                  y: elementRect.maxY))
        context.stroke(legPath, with: .color(Color.primary))
        
        drawTitle(of: element, in: elementRect)
    }
    
    private func drawUseCase(element: UMLElement, elementRect: CGRect) {
        let circlePath = Path(ellipseIn: elementRect)
        context.fill(circlePath, with: .color(Color(UIColor.systemBackground)))
        context.stroke(circlePath, with: .color(Color.primary))
        drawTitle(of: element, in: elementRect)
    }
    
    private func drawTitle(of element: UMLElement, in elementRect: CGRect) {
        var text = Text(element.name ?? "")
        text = text.font(.system(size: fontSize, weight: .bold))
        
        let elementTitle = context.resolve(text)
        let titleSize = elementTitle.measure(in: elementRect.size)
        
        var titleRect: CGRect
        
        switch element.type {
        case .useCaseSystem:
            titleRect = CGRect(x: elementRect.midX - titleSize.width / 2,
                               y: elementRect.minY + 5,
                               width: titleSize.width,
                               height: titleSize.height)
        case .useCase:
            titleRect = CGRect(x: elementRect.midX - titleSize.width / 2,
                               y: elementRect.midY - titleSize.height / 2,
                               width: titleSize.width,
                               height: titleSize.height)
        case .useCaseActor:
            titleRect = CGRect(x: elementRect.midX - titleSize.width / 2,
                               y: elementRect.maxY,
                               width: titleSize.width,
                               height: titleSize.height)
        default:
            titleRect = CGRect(x: elementRect.midX - titleSize.width / 2,
                               y: elementRect.minY + 5,
                               width: titleSize.width,
                               height: titleSize.height)
        }
        
        context.draw(elementTitle, in: titleRect)
    }


    private func drawUnknownElement(element: UMLElement, elementRect: CGRect) {
        log.warning("Drawing logic for elements of type \(element.type?.rawValue ?? "nil") is not implemented")
        context.stroke(Path(elementRect), with: .color(Color.secondary))
    }
}
