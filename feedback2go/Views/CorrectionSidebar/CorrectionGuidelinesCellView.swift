//
//  CorrectionGuidelinesView.swift
//  feedback2go
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct CorrectionGuidelinesCellView: View {
    @ObservedObject var correctionGuidelinesModel: CorrectionGuidelines

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 40) {
                Text("Correction Guidelines")
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Assessment Instructions").font(.title2)

                    Text(correctionGuidelinesModel.gradingInstructions).padding()
                }.padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Structured Assessment Criteria").font(.title2)

                    ForEach(correctionGuidelinesModel.gradingCriteria) { gradingCriterium in
                        GradingCriteriaCellView(gradingCriteriaModel: gradingCriterium, gradingCriteriaID: gradingCriterium.id)
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
        CorrectionGuidelinesCellView(correctionGuidelinesModel: CorrectionGuidelines.mock)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
