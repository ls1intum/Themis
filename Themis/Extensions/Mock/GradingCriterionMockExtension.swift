//
//  GradingCriterionMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 15.10.23.
//

import Foundation
import SharedModels

extension GradingCriterion {
    static var mock: Self {
        .init(id: 1,
              title: "Grading Criterion Title",
              structuredGradingInstructions: [
                .init(id: 1,
                      credits: 10,
                      gradingScale: "Title",
                      instructionDescription: "Some instruction here",
                      feedback: "feedback",
                      usageCount: 2),
                .init(id: 2,
                      credits: 0,
                      gradingScale: "Title",
                      instructionDescription: "Some instruction here",
                      feedback: "feedback",
                      usageCount: 0),
                .init(id: 3,
                      credits: -10,
                      gradingScale: "Title",
                      instructionDescription: "Some instruction here",
                      feedback: "feedback")
              ])
    }
}
