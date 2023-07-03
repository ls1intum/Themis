//
//  ParticipationExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 06.05.23.
//
// swiftlint:disable identifier_name

import Foundation
import SharedModels

extension BaseParticipation {
    func getExercise<T>(as: T.Type = (any BaseExercise).self) -> T? {
        let exercise = self.exercise?.baseExercise
        return exercise as? T
    }
    
    /// A convenience function that casts this BaseParticipation instance into a ProgrammingExerciseStudentParticipation and sets its exercise property
    func setProgrammingExercise(_ exercise: Exercise) {
        (self as? ProgrammingExerciseStudentParticipation)?.exercise = exercise
    }
}

extension Participation {
    func getExercise<T>(as: T.Type = (any BaseExercise).self) -> T? {
        self.baseParticipation.getExercise(as: T.self)
    }
}
