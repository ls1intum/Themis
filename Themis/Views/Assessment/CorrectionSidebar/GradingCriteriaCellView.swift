//
//  GradingCriteriaCellView.swift
//  Themis
//
//  Created by Florian Huber on 20.11.22.
//


import Foundation
import SwiftUI


struct GradingCriteriaCellView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let gradingCriterion: GradingCriterion
    
    var detailText: Binding<String>?
    var score: Binding<Double>?

    var body: some View {

        VStack(alignment: .leading) {
            if let gradingCriterionTitle = gradingCriterion.title {
                Text(gradingCriterionTitle).font(.title3)
            }
            
            ForEach(gradingCriterion.structuredGradingInstructions) { instruction in
                Button {
//                    self.detailText?.wrappedValue = instruction.instructionDescription
                    self.detailText?.wrappedValue = instruction.feedback
                    self.score?.wrappedValue = instruction.credits
                } label: {
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
                .disabled(detailText == nil || score == nil)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
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
