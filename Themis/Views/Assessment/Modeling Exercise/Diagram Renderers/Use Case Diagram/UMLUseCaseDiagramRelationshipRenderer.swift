//
//  UMLUseCaseDiagramRelationshipRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.08.23.
//

import SwiftUI
import Common

struct UMLUseCaseDiagramRelationshipRenderer: UMLDiagramRenderer {
    var context: GraphicsContext
    let canvasBounds: CGRect
    
    private let fontSize: CGFloat = 14
    
    func render(umlModel: UMLModel) {
        guard let relationships = umlModel.relationships else {
            log.warning("The UML model contains no relationships")
            return
        }
        
        return
//        for relationship in relationships {
//            draw(relationship: relationship)
//        }
    }
    
}
