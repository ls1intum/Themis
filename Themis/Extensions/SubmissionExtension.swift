//
//  SubmissionExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.05.23.
//
// swiftlint:disable identifier_name

import Foundation
import SharedModels

extension BaseSubmission {
    func get<T>(as: T.Type = BaseParticipation.self) -> T? {
        self as? T
    }

    func getParticipation<T>(as: T.Type = BaseParticipation.self) -> T? {
        let participation = self.participation?.baseParticipation
        return participation as? T
    }
    
    func getExercise<T>(as: T.Type = (any BaseExercise).self) -> T? {
        self.getParticipation()?.getExercise(as: T.self)
    }
}

extension Submission {
    func getParticipation<T>(as: T.Type = BaseParticipation.self) -> T? {
        self.baseSubmission.getParticipation(as: T.self)
    }
}
