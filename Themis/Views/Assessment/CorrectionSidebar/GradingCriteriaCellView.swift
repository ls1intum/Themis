//
//  GradingCriteriaCellView.swift
//  Themis
//
//  Created by Florian Huber on 20.11.22.
//


import Foundation
import SwiftUI
import SharedModels

struct GradingCriteriaCellView: View {
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
                    self.detailText?.wrappedValue = instruction.feedback ?? ""
                    self.score?.wrappedValue = instruction.credits ?? 0.0
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(instruction.gradingScale ?? "")
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(String(format: "%.1f", instruction.credits ?? 0.0) + "P")
                                .font(.title3)
                        }

                        Divider()

                        Text(instruction.instructionDescription ?? "")
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.getBackgroundColor(forCredits: instruction.credits ?? 0.0)))
                }
                .disabled(detailText == nil || score == nil)
                .foregroundColor(Color.primary)
            }
        }.padding()
    }
}
