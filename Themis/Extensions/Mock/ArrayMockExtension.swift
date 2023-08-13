//
//  ArrayMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.08.23.
//

import Foundation
import SharedModels

// TODO: try to combine these 2 extensions into a more general one

extension Array where Element == Exercise {
    /// - Parameters:
    ///   - condition: the condition to be fullfilled for the array to be filled with mock data
    ///   - mockElementCount: the number of mock elements (random if not specified)
    /// - Returns: an instance filled with mock data if the specified condition is true
    func mock(if condition: @autoclosure () -> Bool, mockElementCount: Int? = nil) -> [Exercise] {
        guard condition() else {
            return self
        }
        var mockArray = [Exercise]()
        
        var elementCount = mockElementCount ?? Int.random(in: 1...3)
        
        for _ in 0..<elementCount {
            mockArray.append(.mockText)
        }
        
        return mockArray
    }
}

extension Array where Element == Exam {
    /// - Parameters:
    ///   - condition: the condition to be fullfilled for the array to be filled with mock data
    ///   - mockElementCount: the number of mock elements (random if not specified)
    /// - Returns: an instance filled with mock data if the specified condition is true
    func mock(if condition: @autoclosure () -> Bool, mockElementCount: Int? = nil) -> [Exam] {
        guard condition() else {
            return self
        }
        var mockArray = [Exam]()
        
        var elementCount = mockElementCount ?? Int.random(in: 1...3)
        
        for _ in 0..<elementCount {
            mockArray.append(.mock)
        }
        
        return mockArray
    }
}
