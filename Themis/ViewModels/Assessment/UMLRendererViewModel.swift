//
//  UMLRendererViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import Foundation
import SharedModels
import Common
import SwiftUI

class UMLRendererViewModel: ObservableObject {
    @Published var umlModel: UMLModel?
    
    /// Contains UML elements that do not have a parent. Such elements are a good starting point when we need to determine which element the user tapped on.
    private var orphanElements = [UMLElement]()
    
    @MainActor
    func setup(modelString: String) {
        guard let modelData = modelString.data(using: .utf8) else {
            return
        }
        
        do {
            umlModel = try JSONDecoder().decode(UMLModel.self, from: modelData)
            determineChildren()
            orphanElements = umlModel?.elements?.filter({ $0.owner == nil }) ?? []
        } catch {
            log.error("Could not parse UML string: \(error)")
        }
    }
    
    func render(_ context: inout GraphicsContext, size: CGSize) {
        guard let model = umlModel else {
            log.warning("Could not find UML model")
            return
        }
        
        context.fill(Path(CGRect(origin: .zero, size: size)),
                     with: .color(Color(UIColor.systemBackground)))
        let canvasBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        var renderer: any UMLDiagramRenderer
        
        switch model.type {
        case .classDiagram:
            renderer = UMLClassDiagramRenderer(context: context, canvasBounds: canvasBounds)
        default:
            renderer = UMLClassDiagramRenderer(context: context, canvasBounds: canvasBounds)
            log.error("Attempted to draw an unknown diagram type")
        }
        
        renderer.render(umlModel: model)
    }
    
    func getElementAt(point: CGPoint) -> UMLElement? {
        for element in orphanElements {
            if element.boundsContains(point: point) {
                return element.getChild(at: point) ?? element
            }
        }
        
        return nil
    }
    
    /// Iterates over UML elements to determine their children
    private func determineChildren() {
        guard let elements = umlModel?.elements else {
            log.warning("Could not find elements in the model")
            return
        }
        var potentialChildren = elements.filter({ $0.owner != nil })
        
        for (elementIndex, element) in elements.enumerated().reversed() {
            for (index, potentialChild) in potentialChildren.enumerated().reversed() where potentialChild.owner == element.id {
                elements[elementIndex].addChild(potentialChild)
                potentialChildren.remove(at: index)
            }
        }
        
        umlModel?.elements = elements
    }
}
