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
    var context: UMLGraphicsContext
    let canvasBounds: CGRect
    var fontSize: CGFloat

    init(context: GraphicsContext, canvasBounds: CGRect, fontSize: CGFloat = 14) {
        self.context = UMLGraphicsContext(context)
        self.canvasBounds = canvasBounds
        self.fontSize = fontSize
    }
    
    func render(umlModel: UMLModel) {
        let elementRenderer = UMLClassDiagramElementRenderer(context: context,
                                                             canvasBounds: canvasBounds,
                                                             fontSize: fontSize)
        let relationshipRenderer = UMLClassDiagramRelationshipRenderer(context: context,
                                                                       canvasBounds: canvasBounds,
                                                                       fontSize: fontSize)
        
        elementRenderer.render(umlModel: umlModel)
        relationshipRenderer.render(umlModel: umlModel)
    }
}
