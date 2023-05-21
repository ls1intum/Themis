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
    
    var isDisabled: Bool {
        if case .programming = self {
            return false
        }
        return true
    }
    
    var isSubmissionDueDateOver: Bool {
        if let dueDate = self.baseExercise.dueDate {
            return dueDate <= .now
        }
        return false
    }
    
    var isFormer: Bool {
        if let dueDate = self.baseExercise.assessmentDueDate, dueDate < Date.now {
            return true
        }
        return false
    }
    
    var supportsAssessment: Bool {
        switch self {
        case .quiz(exercise: _), .unknown(exercise: _):
            return false
        default:
            return true
        }
    }
    
    // TODO: check if some variables are unnecessary
    var isCurrentlyInAssessment: Bool {
        supportsAssessment && hasSomethingToAssess
    }
    
    var isViewOnly: Bool {
        supportsAssessment && !hasSomethingToAssess
    }
    
    private var hasSomethingToAssess: Bool {
        (baseExercise.assessmentType != .automatic || (baseExercise.allowComplaintsForAutomaticAssessments ?? false))
        || (baseExercise.allowComplaintsForAutomaticAssessments == false && hasUnfinishedAssessments)
        || baseExercise.numberOfOpenComplaints != 0
        || baseExercise.numberOfOpenMoreFeedbackRequests != 0
    }
    
    private var hasUnfinishedAssessments: Bool {
        // check if there's at least 1 correction round where inTime != number of in time submissions
        baseExercise.numberOfAssessmentsOfCorrectionRounds?
            .contains(where: { $0.inTime != baseExercise.numberOfSubmissions?.inTime }) ?? false
        || baseExercise.totalNumberOfAssessments?.inTime != baseExercise.numberOfSubmissions?.inTime
    }
    
    var isFuture: Bool {
        // exercises without a release date are automatically published
        if let releaseDate = self.baseExercise.releaseDate {
            return Date.now < releaseDate
        }
        return false
    }
}
