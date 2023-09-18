//
//  ExamMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.08.23.
//
// swiftlint:disable all

import Foundation
import SharedModels

extension Exam {
    /// A mock exam
    static var mock: Exam {
        let randomId = Int.random(in: 1...9999)
        let examData = Data("""
        {
            "id": \(randomId),
            "title": "Exam With Class Diagrams",
            "testExam": false,
            "visibleDate": "2023-07-30T12:37:00+02:00",
            "startDate": "2023-07-30T16:29:00+02:00",
            "endDate": "2023-07-30T17:00:00+02:00",
            "publishResultsDate": "2023-10-31T15:50:00+01:00",
            "gracePeriod": 180,
            "workingTime": 1860,
            "startText": "Started",
            "endText": "Ended",
            "confirmationStartText": "Start?",
            "confirmationEndText": "End?",
            "examMaxPoints": 100,
            "randomizeExerciseOrder": false,
            "numberOfExercisesInExam": 1,
            "numberOfCorrectionRoundsInExam": 1,
            "exampleSolutionPublicationDate": "2023-07-30T17:01:00+02:00"
        }
        """.utf8)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(Exam.self, from: examData)
    }
}
// swiftlint:enable all
