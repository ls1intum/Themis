//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Katjana Kosic on 28.11.22.
//

import Foundation
import SwiftUI

struct EditFeedbackView: View {
    @State var feedbackResult: AssessmentResult
    @State var cvm: CodeEditorViewModel

    @State var feedbackText = ""
    @State var score = 0.0
    @Binding var showEditFeedback: Bool

    let maxScore = Double(10)

    let feedback: AssessmentFeedback?
    let edit: Bool
    let type: FeedbackType

    var pickerRange: [Double] {
        Array(stride(from: -1 * maxScore, to: maxScore +  0.5, by: 0.5))
            .sorted { $0 > $1 }
    }
    var title: String {
        edit ? "Edit Feedback" : "Add Feedback"
    }

    func updateFeedback() {
        guard let feedback else {
            return
        }
        feedbackResult.updateFeedback(id: feedback.id, detailText: feedbackText, credits: score)
    }

    private func setStates() {
        guard let feedback else {
            return
        }
        self.feedbackText = feedback.detailText ?? ""
        self.score = feedback.credits
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                Spacer()
                Button {
                    if edit {
                        updateFeedback()
                    } else {
                        cvm.createFeedback(assessmentResult: feedbackResult, detailText: feedbackText, feedbackScore: score, feedbackType: type)
                    }
                    showEditFeedback = false
                } label: {
                    Text("Save")
                }.font(.title)
                    .disabled(feedbackText.isEmpty)
            }
            HStack {
                TextField("Enter your feedback here", text: $feedbackText, axis: .vertical)
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
