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

    let title: String?
    let edit: Bool
    let type: FeedbackType
    var file: Node?
    
    let gradingCriteria: [GradingCriterion]
    
    var feedbackSuggestion: FeedbackSuggestion?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title ?? "Edit Feedback")
                    .font(.largeTitle)
                
                Spacer()
                
                editOrSaveButton
            }
            
            HStack {
                TextField("Enter your feedback here", text: $detailText, axis: .vertical)
                    .foregroundColor(Color.getTextColor(forCredits: score))
                    .submitLabel(.return)
                    .lineLimit(10...40)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.getTextColor(forCredits: score)))
                    .background(Color.getBackgroundColor(forCredits: score))
                
                ScorePicker(score: $score)
            }
            .animation(.easeIn, value: score)
            
            Spacer()
            
            gradingCriteriaList
        }
        .padding()
        .onAppear {
            setStates()
        }
    }
    
    private var gradingCriteriaList: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(gradingCriteria) { gradingCriterion in
                    GradingCriteriaCellView(gradingCriterion: gradingCriterion, detailText: $detailText, score: $score)
                }
            }
        }
    }
    
    private var editOrSaveButton: some View {
        Button {
            if edit {
                updateFeedback()
            } else {
                createFeedback()
            }
            showSheet = false
        } label: {
            Text("Save")
        }
        .font(.title)
        .disabled(detailText.isEmpty)
    }

    private func updateFeedback() {
        if let id = idForUpdate {
            assessmentResult.updateFeedback(id: id, detailText: detailText, credits: score)
        }
    }

    private func createFeedback() {
        if let feedbackSuggestion {
            addFeedbackSuggestionToFeedbacks(feedbackSuggestion: feedbackSuggestion)
        } else if type == .inline {
            let lines: NSRange? = cvm.selectedSectionParsed?.0
            let columns: NSRange? = cvm.selectedSectionParsed?.1
            let feedback = AssessmentFeedback(detailText: detailText, credits: score, type: type, file: file, lines: lines, columns: columns)
            assessmentResult.addFeedback(feedback: feedback)
            cvm.addInlineHighlight(feedbackId: feedback.id)
        } else {
            assessmentResult.addFeedback(feedback: AssessmentFeedback(detailText: detailText, credits: score, type: type))
        }
    }
    
    private func addFeedbackSuggestionToFeedbacks(feedbackSuggestion: FeedbackSuggestion) {
        let lines = NSRange(location: feedbackSuggestion.fromLine, length: feedbackSuggestion.toLine - feedbackSuggestion.fromLine)
        let feedback = AssessmentFeedback(
            detailText: feedbackSuggestion.text,
            credits: feedbackSuggestion.credits,
            type: .inline,
            file: file,
            lines: lines
        )
        assessmentResult.addFeedback(feedback: feedback)
        cvm.addFeedbackSuggestionInlineHighlight(feedbackSuggestion: feedbackSuggestion, feedbackId: feedback.id)
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
}

struct EditFeedbackViewBase_Previews: PreviewProvider {
    static var result = AssessmentResult()
    static var cvm = CodeEditorViewModel()
    
    static var previews: some View {
        EditFeedbackViewBase(assessmentResult: result,
                             cvm: cvm,
                             showSheet: .constant(true),
                             title: "Title",
                             edit: false,
                             type: .inline,
                             gradingCriteria: [
                                .init(id: 1, structuredGradingInstructions: [
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
                                          usageCount: 1),
                                    .init(id: 3,
                                          credits: -10,
                                          gradingScale: "Title",
                                          instructionDescription: "Some instruction here",
                                          feedback: "feedback")
                                ])
                             ])
    }
}
