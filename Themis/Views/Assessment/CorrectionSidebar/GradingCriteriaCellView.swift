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
                    Text(String(format: "%.1f", instruction.credits))
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
