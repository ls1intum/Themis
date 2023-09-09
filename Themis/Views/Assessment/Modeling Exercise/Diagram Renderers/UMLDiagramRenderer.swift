//
//  UMLDiagramRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.08.23.
//

import Foundation

protocol UMLDiagramRenderer {
    /// This instance should be used for all actions that one would normally perform with a `GraphicsContext`
    var context: UMLGraphicsContext { get set }
    var canvasBounds: CGRect { get }
    var fontSize: CGFloat { get set }
    
    func render(umlModel: UMLModel)
}
