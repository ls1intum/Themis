//
//  NSRangeUtils.swift
//  
//
//  Created by Paul Schwind on 11.12.22.
//

import Foundation

extension NSRange {
    /// Converts safely to a NSRange, without any indices out of bounds for text.
    func makeSafeFor(_ text: String) -> NSRange {
        let lower = max(0, lowerBound)
        let upper = min(text.count - 1, upperBound)
        if lower >= upper {
            return NSRange()
        }
        return (lower..<upper + 1).toNSRange()
    }
}
