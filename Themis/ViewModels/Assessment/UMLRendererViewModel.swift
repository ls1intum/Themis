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
    @Published var selectedElement: UMLElement?
    
    /// Contains UML elements that do not have a parent. Such elements are a good starting point when we need to determine which element the user tapped on.
    private var orphanElements = [UMLElement]()
    
    /// Sets this VM up based on the given submission
    @MainActor
    func setup(basedOn submission: BaseSubmission? = nil) {
        guard let modelingSubmission = submission as? ModelingSubmission,
                  let modelData = modelingSubmission.model?.data(using: .utf8) else {
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
    
    func renderHighlights(_ context: inout GraphicsContext, size: CGSize) {
        guard let selectedElement,
              let xCoordinate = selectedElement.bounds?.x,
              let yCoordinate = selectedElement.bounds?.y,
              let width = selectedElement.bounds?.width,
              let height = selectedElement.bounds?.height else {
            log.error("Could not draw highlight")
            return
        }
        
        let elementRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        context.fill(Path(elementRect), with: .color(Color.yellow.opacity(0.5)))
    }
    
    func selectElement(at point: CGPoint) {
        selectedElement = getElement(at: point)
        log.verbose("Selected UML element: \(selectedElement?.name ?? "no name")")
    }
    
    private func getElement(at point: CGPoint) -> UMLElement? {
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
