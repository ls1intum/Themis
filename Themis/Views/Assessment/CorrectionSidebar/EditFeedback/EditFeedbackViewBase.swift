//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Katjana Kosic on 28.11.22.
//

import Foundation
import SwiftUI

struct EditFeedbackViewBase: View {
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel

    @Binding var feedback: AssessmentFeedback
    @State var detailText = ""
    @State var score = 0.0
    @Binding var showSheet: Bool

    let maxScore = Double(10)

    let title: String?
    let edit: Bool
    let type: FeedbackType

    var pickerRange: [Double] {
        Array(stride(from: -1 * maxScore, to: maxScore + 0.5, by: 0.5))
            .sorted { $0 > $1 }
    }

    func updateFeedback() {
        feedback.updateFeedback(detailText: detailText, credits: score)
        assessmentResult.updateFeedback(
            id: feedback.id,
            feedback: feedback
        )
    }

    func createFeedback() {
        feedback.detailText = detailText
        feedback.credits = score
        if type == .inline {
            cvm.addInlineHighlight(feedbackID: feedback.id)
        }
        assessmentResult.addFeedback(feedback: feedback)
    }

    private func setStates() {
        self.detailText = feedback.detailText ?? ""
        self.score = feedback.credits
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title ?? "Edit feedback")
                    .font(.largeTitle)
                Spacer()
                Button {
                    if edit {
                        updateFeedback()
                    } else {
                        createFeedback()
                    }
                    showSheet = false
                } label: {
                    Text("Save")
                }.font(.title)
                    .disabled(detailText.isEmpty)
            }
            HStack {
                TextField("Enter your feedback here", text: $detailText, axis: .vertical)
                    .submitLabel(.return)
                    .lineLimit(10...40)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2))
                Text("Score:")
                    .font(.title)
                    .padding(.leading)
                Picker("Score", selection: $score) {
                    ForEach(pickerRange, id: \.self) { number in
                        if number < 0.0 {
                            Text(String(format: "%.1f", number)).foregroundColor(.red)
                        } else if number > 0.0 {
                            Text(String(format: "%.1f", number)).foregroundColor(.green)
                        } else {
                            Text(String(format: "%.1f", number))
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 150)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            setStates()
        }
    }
}
