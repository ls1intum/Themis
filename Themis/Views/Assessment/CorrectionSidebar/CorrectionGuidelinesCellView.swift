//
//  CorrectionGuidelinesView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct CorrectionGuidelinesCellView: View {
    @EnvironmentObject var assessment: AssessmentViewModel

    var gradingCriteria: [GradingCriterion] {
        guard let criteria = assessment.submission?.participation.exercise.gradingCriteria else {
            return []
        }
        return criteria
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

                LazyVStack(alignment: .leading, spacing: 10) {
                    Text("Assessment Criteria").font(.title2)

                    ForEach(gradingCriteria) { gradingCriterion in
                        GradingCriteriaCellView(gradingCriterion: gradingCriterion)
                    }
                }.padding()

                Spacer()
            }
        }.padding()
    }
}

struct CorrectionGuidelinesCellView_Previews: PreviewProvider {
    static var assessment = AssessmentViewModel(readOnly: false)

    static var previews: some View {
        CorrectionGuidelinesCellView()
            .environmentObject(assessment)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
