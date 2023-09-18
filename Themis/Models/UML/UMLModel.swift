//
//  UMLModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.07.23.
//
import Foundation
import SharedModels

struct UMLModel: Decodable {
    let version: String?
    let type: UMLDiagramType?
    let size: Size?
    var elements: [UMLElement]?
    let relationships: [UMLRelationship]?
}

struct Size: Decodable {
    let width: Double
    let height: Double
    
    var asCGSize: CGSize {
        CGSize(width: width, height: height)
    }
}
