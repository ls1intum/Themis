//
//  GradingCriteriaCellView.swift
//  feedback2go
//
//  Created by Florian Huber on 20.11.22.
//

import Foundation
import SwiftUI

struct GradingCriteriaCellView: View {
    @ObservedObject var gradingCriteriaModel: GradingCriteria
    var gradingCriteriaID: GradingCriteria.ID

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(String(gradingCriteriaModel.credits))
                    .font(.title3)
                Spacer()
                Text(gradingCriteriaModel.gradingScale)
                    .font(.title3)
                Spacer()
                Text(gradingCriteriaModel.instructionDescription)
                    .font(.title3)
            }
        }.padding()
    }
}

struct GradingCriteria_Previews: PreviewProvider {
    private static let mock: CorrectionGuidelines = CorrectionGuidelines.mock

    static var previews: some View {
        GradingCriteriaCellView(gradingCriteriaModel: mock.gradingCriteria[0], gradingCriteriaID: mock.gradingCriteria[0].id)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
