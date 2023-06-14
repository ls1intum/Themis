//
//  ExamExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation
import SharedModels

extension Exam {
    var isOver: Bool {
        if let endDate = self.endDate {
            return endDate <= .now
        }
        return false
    }
    
    var isAssessmentDue: Bool {
        if let publishResultsDate = self.publishResultsDate {
            return publishResultsDate <= .now
        }
        return false
    }
    
    public var exercises: [Exercise] {
        let exercises = exerciseGroups?.reduce([]) { $0 + ($1.exercises ?? []) } as? [Exercise]
        return exercises ?? []
    }
}
