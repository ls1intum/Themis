//
//  RangeUtils.swift
//  Themis
//
//  Created by Paul Schwind on 11.12.22.
//

import Foundation

public extension Range<Int> {
    func toNSRange() -> NSRange {
        return NSRange(location: lowerBound, length: count)
    }
}
