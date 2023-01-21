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

public extension Range where Element == Int {
    static func from(arr: [Int]) -> [Range<Int>] {
        arr.reduce(into: [Range<Int>]()) { ranges, elem in
            if let range = ranges.last, range.upperBound + 1 == elem {
                ranges[ranges.count - 1] = range.lowerBound..<elem + 1
            } else {
                ranges.append(elem..<elem + 1)
            }
        }
    }
}
