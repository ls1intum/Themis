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
        
        var mockArray = [Any]()
        
        let elementCount = mockElementCount ?? Int.random(in: 1...3)
        
        for _ in 0..<elementCount {
            var elementToBeCloned: Any
            
            switch Element.self {
            case is Exercise.Type:
                elementToBeCloned = Exercise.mockText
            case is Exam.Type:
                elementToBeCloned = Exam.mock
            case is Submission.Type:
                elementToBeCloned = Submission.mockText
            default:
                log.debug("Could not determine mock type for: \(type(of: self))")
                continue
            }
            
            mockArray.append(elementToBeCloned)
        }
        
        if let result = mockArray as? [Element] {
            return result
        } else {
            log.debug("Could not correctly generate mock for type: \(type(of: self))")
            return []
        }
    }
}
