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
        case .Class, .abstractClass, .enumeration:
            drawClassLikeElement(element: element, elementRect: elementRect)
        case .classMethod, .classAttribute:
            drawClassLikeElement(element: element, elementRect: elementRect)
        case .package:
            drawPackage(element: element, elementRect: elementRect)
        default:
            drawUnknownElement(element: element, elementRect: elementRect)
        }
    }
    
    private func drawClassLikeElement(element: UMLElement, elementRect: CGRect) {
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
        context.stroke(Path(topCornerRect), with: .color(Color.primary))
        
        let newElementRect = CGRect(x: elementRect.minX,
                                    y: elementRect.minY + topCornerRect.height,
                                    width: elementRect.width,
                                    height: elementRect.height - topCornerRect.height)
        
        context.stroke(Path(newElementRect), with: .color(Color.primary))
        drawTitle(of: element, in: newElementRect)
    }
    
    private func drawUnknownElement(element: UMLElement, elementRect: CGRect) {
        log.warning("Drawing logic for elements of type \(element.type?.rawValue ?? "nil") is not implemented")
        context.stroke(Path(elementRect), with: .color(Color.secondary))
    }
    
    private func drawTitle(of element: UMLElement, in elementRect: CGRect) {
        var text = Text(element.name ?? "")
        text = text.font(.system(size: fontSize, weight: .bold))
        
        let elementTitle = context.resolve(text)
        let titleSize = elementTitle.measure(in: elementRect.size)
        let titleRect = CGRect(x: elementRect.midX - titleSize.width / 2,
                               y: elementRect.minY,
                               width: titleSize.width,
                               height: titleSize.height)
        
        context.draw(elementTitle, in: titleRect)
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
