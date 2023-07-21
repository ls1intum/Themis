//
//  FloatingPointExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 14.07.23.
//

import Foundation

extension FloatingPoint {
    func clamped(to range: ClosedRange<Self>) -> Self {
        max(min(self, range.upperBound), range.lowerBound)
    }
}
