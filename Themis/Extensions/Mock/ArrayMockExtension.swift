//
//  ArrayMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.08.23.
//

import Foundation
import SharedModels
import Common

extension Array {
    /// - Parameters:
    ///   - condition: the condition to be fullfilled for the array to be filled with mock data
    ///   - mockElementCount: the number of mock elements (random if not specified)
    /// - Returns: an instance filled with mock data if the specified condition is true
    func mock(if condition: @autoclosure () -> Bool, mockElementCount: Int? = nil) -> Self {
        guard condition() else {
            return self
        }
        
        var mockArray = [Element]()
        var elementToBeCloned: Element?
        
        switch self {
        case is [Exercise]:
            elementToBeCloned = Exercise.mockText as? Element
        case is [Exam]:
            elementToBeCloned = Exam.mock as? Element
        default:
            log.debug("Could not generate mock for type: \(type(of: self))")
        }
        
        var elementCount = mockElementCount ?? Int.random(in: 1...3)
        
        if let elementToBeCloned {
            for _ in 0..<elementCount {
                mockArray.append(elementToBeCloned)
            }
        } else {
            log.debug("Could not generate a correct mock value for type: \(type(of: self))")
        }
        
        return mockArray
    }
}
