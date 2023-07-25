//
//  SelectableUMLItem.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 25.07.23.
//

import Foundation

protocol SelectableUMLItem {
    var id: String? { get }
    var name: String? { get }
    var owner: String? { get }
    var bounds: Boundary? { get }
    var boundsAsCGRect: CGRect? { get }
}

extension SelectableUMLItem {
    var boundsAsCGRect: CGRect? { // default implementation for all conforming types
        guard let xCoordinate = bounds?.x,
              let yCoordinate = bounds?.y,
              let width = bounds?.width,
              let height = bounds?.height else {
            return nil
        }
        return CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
    }
}
