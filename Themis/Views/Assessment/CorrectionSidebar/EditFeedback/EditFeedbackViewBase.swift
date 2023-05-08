//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Katjana Kosic on 28.11.22.
//

import Foundation
import SwiftUI
import CodeEditor
import SharedModels

struct EditFeedbackViewBase: View {
    var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel

    @State var detailText = ""
    @State var score = 0.0
    @Binding var showSheet: Bool
    
    var idForUpdate: UUID?

    let title: String?
    let edit: Bool
    let scope: ThemisFeedbackScope
    
    let gradingCriteria: [GradingCriterion]
    
    var feedbackSuggestion: FeedbackSuggestion?
    
    private var isEditing: Bool {
        idForUpdate != nil
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title ?? "Edit Feedback")
                    .font(.largeTitle)
                
                Spacer()
                
                if isEditing {
                    deleteButton
                }
                
                editOrSaveButton
            }
            
            HStack(spacing: 15) {
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
                    .frame(maxWidth: 130)
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
        .buttonStyle(ThemisButtonStyle())
        .font(.title2)
        .disabled(detailText.isEmpty)
    }
    
    private var deleteButton: some View {
        Button {
            deleteFeedback()
            showSheet = false
        } label: {
            Image(systemName: "trash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 27)
        }
        .buttonStyle(ThemisButtonStyle(color: .themisRed))
        .font(.title2)
    }
    
    private func updateFeedback() {
        if let id = idForUpdate {
            assessmentResult.updateFeedback(id: id, detailText: detailText, credits: score)
        }
    }

    private func createFeedback() {
        if let feedbackSuggestion {
            addFeedbackSuggestionToFeedbacks(feedbackSuggestion: feedbackSuggestion)
        } else if scope == .inline {
            let lines: NSRange? = cvm.selectedSectionParsed?.0
            let columns: NSRange? = cvm.selectedSectionParsed?.1
            let feedback = AssessmentFeedback(baseFeedback: Feedback(detailText: detailText, credits: score, type: .MANUAL),
                                              scope: scope,
                                              file: cvm.selectedFile,
                                              lines: lines,
                                              columns: columns)
            assessmentResult.addFeedback(feedback: feedback)
            cvm.addInlineHighlight(feedbackId: feedback.id)
        } else {
            assessmentResult.addFeedback(feedback: AssessmentFeedback(baseFeedback: Feedback(detailText: detailText,
                                                                                             credits: score,
                                                                                             type: .MANUAL_UNREFERENCED),
                                                                      scope: scope))
        }
    }
    
    private func deleteFeedback() {
        guard let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) else {
            return
        }
        assessmentResult.deleteFeedback(id: feedback.id)
        cvm.deleteInlineHighlight(feedback: feedback)
    }
    
    private func addFeedbackSuggestionToFeedbacks(feedbackSuggestion: FeedbackSuggestion) {
        let lines = NSRange(location: feedbackSuggestion.fromLine, length: feedbackSuggestion.toLine - feedbackSuggestion.fromLine)
        let feedback = AssessmentFeedback(
            baseFeedback: Feedback(detailText: feedbackSuggestion.text,
                                   credits: feedbackSuggestion.credits,
                                   type: .MANUAL_UNREFERENCED),
            scope: .inline,
            file: cvm.selectedFile,
            lines: lines
        )
        assessmentResult.addFeedback(feedback: feedback)
        cvm.addFeedbackSuggestionInlineHighlight(feedbackSuggestion: feedbackSuggestion, feedbackId: feedback.id)
    }

    private func setStates() {
        if idForUpdate != nil {
            if let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) {
                self.detailText = feedback.baseFeedback.detailText ?? ""
                self.score = feedback.baseFeedback.credits ?? 0.0
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
                             scope: .inline,
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
