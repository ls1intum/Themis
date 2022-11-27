//
//  CorrectionGuidelinesView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct CorrectionGuidelinesCellView: View {
    @EnvironmentObject var assessment: AssessmentViewModel

    var gradingCriteria: [GradingCriteria] {
        if let criteria = assessment.submission?.participation.exercise.gradingCriteria {
            return criteria
        }
        return []
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 40) {
                Text("Correction Guidelines")
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Assessment Instructions").font(.title2)

                    Text(assessment.submission?.participation.exercise.gradingInstructions ?? "").padding()
                }.padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Structured Assessment Criteria").font(.title2)
                    ForEach(gradingCriteria) { gradingCriterium in
                        GradingCriteriaCellView(gradingCriterium: gradingCriterium)
                    }.padding()
                }.padding()

                Spacer()
            }

            // Spacer()
        }.padding()
    }
}

struct CorrectionGuidelinesCellView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionGuidelinesCellView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
