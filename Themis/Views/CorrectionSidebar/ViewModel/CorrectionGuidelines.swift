//
//  CorrectionGuidelines.swift
//  Themis
//
//  Created by Florian Huber on 20.11.22.
//

import Foundation

class GradingCriteria: ObservableObject, Identifiable {
    public var id: UUID
    public var credits: Double
    public var gradingScale: String
    public var instructionDescription: String
    public var feedback: String
    public var usageCount: Int

    init(id: UUID? = nil, credits: Double, gradingScale: String, instructionDescription: String, feedback: String, usageCount: Int) {
        self.id = id ?? UUID()
        self.credits = credits
        self.gradingScale = gradingScale
        self.instructionDescription = instructionDescription
        self.feedback = feedback
        self.usageCount = usageCount
    }
}

public class CorrectionGuidelines: ObservableObject {
    public var id: UUID
    var gradingCriteria: [GradingCriteria]
    var gradingInstructions: String

    init(id: UUID? = nil, gradingCriteria: [GradingCriteria], gradingInstructions: String) {
        self.id = id ?? UUID()
        self.gradingCriteria = gradingCriteria
        self.gradingInstructions = gradingInstructions
    }

    public static var mock: CorrectionGuidelines {
        let gradingCriteria = GradingCriteria(
            credits: 2.0,
            gradingScale: "Perfect",
            instructionDescription: "Test",
            feedback: "very good",
            usageCount: 0
        )
        let correctionGuidelines = CorrectionGuidelines(
            gradingCriteria: [gradingCriteria],
            gradingInstructions: "Add Assessment Instruction text here"
        )
        return correctionGuidelines
    }
}
