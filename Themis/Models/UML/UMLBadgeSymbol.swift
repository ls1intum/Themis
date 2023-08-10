//
//  UMLBadgeSymbol.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 25.07.23.
//

import SwiftUI

/// Represents a badge symbol for UML elements having an associated referenced feedback
enum UMLBadgeSymbol {
    case checkmark
    case cross
    case exclamation
    
    var imageName: String {
        switch self {
        case .checkmark:
            return "checkmark-badge"
        case .cross:
            return "xmark-badge"
        case .exclamation:
            return "exclamation-badge"
        }
    }
    
    static func symbol(forCredits credits: Double) -> Self {
        if credits < 0.0 {
            return Self.cross
        } else if credits > 0.0 {
            return Self.checkmark
        } else {
            return Self.exclamation
        }
    }
}
