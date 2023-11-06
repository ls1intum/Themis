//
//  ComparableExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 14.07.23.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
