//
//  UMLUseCaseDiagramRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.08.23.
//

import SwiftUI

struct UMLUseCaseDiagramRenderer: UMLDiagramRenderer {
    var context: UMLGraphicsContext
    let canvasBounds: CGRect
    
    private let fontSize: CGFloat = 14
    
    init(context: GraphicsContext, canvasBounds: CGRect) {
        self.context = UMLGraphicsContext(context)
        self.canvasBounds = canvasBounds
    }
    
    func render(umlModel: UMLModel) {
        let elementRenderer = UMLUseCaseDiagramElementRenderer(context: context, canvasBounds: canvasBounds)
        let relationshipRenderer = UMLUseCaseDiagramRelationshipRenderer(context: context, canvasBounds: canvasBounds)
        
        elementRenderer.render(umlModel: umlModel)
        relationshipRenderer.render(umlModel: umlModel)
    }
}
