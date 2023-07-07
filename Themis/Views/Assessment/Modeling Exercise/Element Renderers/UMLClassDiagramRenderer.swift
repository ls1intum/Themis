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
            drawClass(element: element, elementRect: elementRect)
        case .package:
            drawClass(element: element, elementRect: elementRect) // TODO: change
        default:
            drawClass(element: element, elementRect: elementRect) // TODO: change
            log.warning("Drawing logic for elements of type \(element.type?.rawValue ?? "nil") is not implemented")
        }
    }
    
    private func drawClass(element: UMLElement, elementRect: CGRect) {
        context.stroke(Path(elementRect), with: .color(Color.primary))
        drawTitle(element: element, elementRect: elementRect)
    }
    
    private func drawTitle(element: UMLElement, elementRect: CGRect) {
        var text = Text(element.name ?? "")
        
        if element.type != .classAttribute && element.type != .classMethod {
            text = text.font(.system(size: 15, weight: .bold))
        }
        
        let elementTitle = context.resolve(text)
        
//        let titleX = elementRect.origin.x + elementRect.width / 2 - elementTitle.
        
        context.draw(elementTitle, in: elementRect)
    }
}
