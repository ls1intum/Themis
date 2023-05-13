//
//  CorrectionGuidelinesView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import SharedModels

struct CorrectionGuidelinesCellView: View {
    let gradingCriteria: [GradingCriterion]
    let gradingInstructions: String?

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {
            Text("Correction Guidelines")
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 0) {
                Text("Assessment Instructions").font(.title2)

                Text(gradingInstructions ?? "").padding()
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Assessment Criteria").font(.title2)

                ForEach(gradingCriteria) { gradingCriterion in
                    GradingCriteriaCellView(gradingCriterion: gradingCriterion)
                }
            }

            Spacer()
        }.padding()
    }
}

struct CorrectionGuidelinesCellView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionGuidelinesCellView(gradingCriteria: [
            .init(id: 1, structuredGradingInstructions: [
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
                      usageCount: 1),
                .init(id: 3,
                      credits: -10,
                      gradingScale: "Title",
                      instructionDescription: "Some instruction here",
                      feedback: "feedback")
            ])
        ], gradingInstructions: "Some general assessment instruction here")
    }
}
