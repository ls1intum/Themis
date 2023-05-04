//
//  ExerciseExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//

import Foundation
import SharedModels

extension Exercise {
    
    var assessmentDueDateString: String? {
        ArtemisDateHelpers.stringifyDate(self.baseExercise.assessmentDueDate)
    }
    
    var dueDateString: String? {
        ArtemisDateHelpers.stringifyDate(self.baseExercise.dueDate)
    }
    
    var releaseDateString: String? {
        ArtemisDateHelpers.stringifyDate(self.baseExercise.releaseDate)
    }
    
    var disabled: Bool {
        if case .programming = self {
            return true
        }
        return false
    }

    func isFormer() -> Bool {
        if let dueDate = self.baseExercise.assessmentDueDate, dueDate < Date.now {
            return true
        }
        return false
    }
    
    func isCurrent() -> Bool {
        if let releaseDate = self.baseExercise.releaseDate {
            return Date.now >= releaseDate
        }
        return !isFormer()
    }
    
    func isFuture() -> Bool {
        // exercises without a release date are automatically published
        if let releaseDate = self.baseExercise.releaseDate {
            return Date.now < releaseDate
        }
        return false
    }
}

extension ArtemisAPI {
    static func getExercise(exerciseId: Int) async throws -> Exercise {
        let request = Request(method: .get, path: "/api/exercises/\(exerciseId)/for-assessment-dashboard")
        return try await sendRequest(Exercise.self, request: request)
    }
}
