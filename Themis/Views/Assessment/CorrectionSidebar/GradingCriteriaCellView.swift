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
    
    var selectedGradingInstruction: Binding<GradingInstruction?>?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let gradingCriterionTitle = gradingCriterion.title {
                Text(gradingCriterionTitle).font(.title3)
            }
            
            ForEach(gradingCriterion.structuredGradingInstructions) { instruction in
                Button {
                    self.selectedGradingInstruction?.wrappedValue = instruction
                } label: {
                    cellView(for: instruction)
                }
                .disabled(selectedGradingInstruction == nil)
                .foregroundColor(Color.primary)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func cellView(for instruction: GradingInstruction) -> some View {
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
            
            HStack {
                Text(instruction.instructionDescription ?? "")
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let limit = instruction.usageCount {
                    Text("Limit: \(limit == 0 ? "∞" : "\(limit)")")
                }
            }
        }
        .padding()
        .background { backgroundView(for: instruction) }
    }
    
    @ViewBuilder
    private func backgroundView(for instruction: GradingInstruction) -> some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.getBackgroundColor(forCredits: instruction.credits ?? 0.0))
            
            if instruction == selectedGradingInstruction?.wrappedValue {
                Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 25))
                    .offset(x: 10, y: -10)
                    .foregroundStyle(.secondary)
                    .transition(.scale)
            }
        }
    }
}

struct GradingCriteriaCellView_Previews: PreviewProvider {
    @State private static var selectedInstruction: GradingInstruction?
    
    static let gradingInstruction = GradingCriterion(id: 1,
                                                     title: "Grading Criterion Title",
                                                     structuredGradingInstructions: [
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
                                                              usageCount: 0),
                                                        .init(id: 3,
                                                              credits: -10,
                                                              gradingScale: "Title",
                                                              instructionDescription: "Some instruction here",
                                                              feedback: "feedback")
                                                     ])
    
    static var previews: some View {
        GradingCriteriaCellView(gradingCriterion: gradingInstruction,
                                selectedGradingInstruction: $selectedInstruction)
    }
}
