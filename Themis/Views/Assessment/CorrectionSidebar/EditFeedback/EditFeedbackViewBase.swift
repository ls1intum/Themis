//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Katjana Kosic on 28.11.22.
//

import Foundation
import SwiftUI
import CodeEditor

struct EditFeedbackViewBase: View {
    var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel

    @State var detailText = ""
    @State var score = 0.0
    @Binding var showSheet: Bool
    
    var idForUpdate: UUID?

    let maxScore = Double(10)

    let title: String?
    let edit: Bool
    let type: FeedbackType
    var file: Node?
    
    let gradingCriteria: [GradingCriterion]
    
    var feedbackSuggestion: FeedbackSuggestion?

    var pickerRange: [Double] {
        Array(stride(from: -1 * maxScore, to: maxScore + 0.5, by: 0.5))
            .sorted { $0 > $1 }
    }

    private func updateFeedback() {
        if let id = idForUpdate {
            assessmentResult.updateFeedback(id: id, detailText: detailText, credits: score)
        }
    }

    private func createFeedback() {
        if type == .inline {
            let lines: NSRange? = cvm.selectedSectionParsed?.0
            let columns: NSRange? = cvm.selectedSectionParsed?.1
            let feedback = AssessmentFeedback(detailText: detailText, credits: score, type: type, file: file, lines: lines, columns: columns)
            assessmentResult.addFeedback(feedback: feedback)
            cvm.addInlineHighlight(feedbackId: feedback.id)
        } else {
            assessmentResult.addFeedback(feedback: AssessmentFeedback(detailText: detailText, credits: score, type: type))
        }
    }

    private func setStates() {
        if idForUpdate != nil {
            if let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) {
                self.detailText = feedback.detailText ?? ""
                self.score = feedback.credits
            }
        }
        if let feedbackSuggestion = feedbackSuggestion {
            self.detailText = feedbackSuggestion.text
            self.score = feedbackSuggestion.credits
        }
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
                .animation(.default, value: score)
            }
            Spacer()
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(gradingCriteria) { gradingCriterion in
                        GradingCriteriaCellView(gradingCriterion: gradingCriterion, detailText: $detailText, score: $score)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            setStates()
        }
    }
}
