//
//  RangeUtils.swift
//  Themis
//
//  Created by Paul Schwind on 11.12.22.
//

import Foundation

public extension Range<Int> {
    func toNSRange() -> NSRange {
        NSRange(location: lowerBound, length: count)
    }
}
