//
//  UMLClassDiagramRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.07.23.
//

import SwiftUI
import Common
import SharedModels

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
