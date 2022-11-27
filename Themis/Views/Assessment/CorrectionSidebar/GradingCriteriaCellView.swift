//
//  GradingCriteriaCellView.swift
//  Themis
//
//  Created by Florian Huber on 20.11.22.
//

import Foundation
import SwiftUI

struct GradingCriteriaCellView: View {
    let gradingCriterium: GradingCriteria

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(gradingCriterium.structuredGradingInstructions) { instruction in
                HStack {
                    Text("\(instruction.credits)")
                        .font(.title3)
                    Spacer()
                    Text(instruction.gradingScale)
                        .font(.title3)
                    Spacer()
                    Text(instruction.instructionDescription)
                        .font(.title3)
                }
            }
        }.padding()
    }
}

struct GradingCriteria_Previews: PreviewProvider {
    static var previews: some View {
        GradingCriteriaCellView(gradingCriterium: GradingCriteria(id: 1, structuredGradingInstructions: [GradingInstruction(id: 1, credits: 22, gradingScale: "asasd", instructionDescription: "asSAdasd", feedback: "asdasdasd", usageCount: 2)]))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
