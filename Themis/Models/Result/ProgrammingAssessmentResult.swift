//
//  ProgrammingAssessmentResult.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 09.06.23.
//

import Foundation
import SharedModels

class ProgrammingAssessmentResult: AssessmentResult {
    override func encode(to encoder: Encoder) throws {
        try ProgrammingAssessmentResultDTO(basedOn: self).encode(to: encoder)
    }
}

struct ProgrammingAssessmentResultDTO: Encodable {
    let score: Double
    let feedbacks: [Feedback]
    let testCaseCount: Int
    let passedTestCaseCount: Int
    
    init(basedOn programmingAssessmentResult: ProgrammingAssessmentResult) {
        self.score = programmingAssessmentResult.score
        self.feedbacks = programmingAssessmentResult.feedbacks.map({ $0.baseFeedback })
        self.testCaseCount = programmingAssessmentResult.automaticFeedback.count
        self.passedTestCaseCount = programmingAssessmentResult.automaticFeedback.filter { $0.baseFeedback.positive ?? false } .count
    }
}
