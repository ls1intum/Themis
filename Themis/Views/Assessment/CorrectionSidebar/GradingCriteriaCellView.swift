//
//  GradingCriteriaCellView.swift
//  Themis
//
//  Created by Florian Huber on 20.11.22.
//

// swiftlint:disable line_length

import Foundation
import SwiftUI

struct GradingCriteriaCellView: View {
    let gradingCriterion: GradingCriterion

    var body: some View {

        VStack(alignment: .leading) {
            if let gradingCriterionTitle = gradingCriterion.title {
                Text(gradingCriterionTitle).font(.title3)
            }

            ForEach(gradingCriterion.structuredGradingInstructions) { instruction in
                VStack(alignment: .leading) {
                    HStack {
                        Text(instruction.gradingScale)
                            .font(.title3)
                        Spacer()
                        Text(String(format: "%.1f", instruction.credits) + "P")
                            .font(.title3)
                    }

                    Divider()

                    Text(instruction.instructionDescription)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(colorize(credits: instruction.credits), lineWidth: 2))
            }
        }.padding()
    }

    private func colorize(credits: Double) -> Color {
        if credits > 0 {
            return .green
        } else if credits == 0.0 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct GradingCriteriaCellView_Previews: PreviewProvider {

    static var previews: some View {
        GradingCriteriaCellView(gradingCriterion: GradingCriterion(id: 1, title: "Car subsystem (3 Points)", structuredGradingInstructions: [GradingInstruction(id: 1, credits: 2.0, gradingScale: "Correct class", instructionDescription: "You found the correct class.", feedback: "Great job!", usageCount: 2), GradingInstruction(id: 2, credits: -2.0, gradingScale: "Wrong class", instructionDescription: "You did not find the right class.", feedback: "Not good...", usageCount: 2), GradingInstruction(id: 3, credits: 0.0, gradingScale: "Missing attributes", instructionDescription: "Missing attributes is not good but it is ok in this case.", feedback: "Please add attributes the next time.", usageCount: 1)]))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
