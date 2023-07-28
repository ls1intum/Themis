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
    weak var feedbackDelegate: (any FeedbackDelegate)?
    var idForUpdate: UUID?
    var incompleteFeedback: AssessmentFeedback?
    var feedbackSuggestion: FeedbackSuggestion?
    
    let title: String?
    let isEditing: Bool
    let scope: ThemisFeedbackScope
    let gradingCriteria: [GradingCriterion]
    
    @Binding var showSheet: Bool
    @State private var detailText = ""
    @State private var score = 0.0
    
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
                
                ScorePicker(score: $score, maxScore: assessmentResult.maxPoints)
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
            if isEditing {
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
        if let id = idForUpdate,
           let updatedFeedback = assessmentResult.updateFeedback(id: id, detailText: detailText, credits: score) {
            feedbackDelegate?.onFeedbackUpdate(updatedFeedback)
        }
    }

    private func createFeedback() {
        if let feedbackSuggestion {
            addFeedbackSuggestionToFeedbacks(feedbackSuggestion: feedbackSuggestion)
        } else if scope == .inline {
            let feedback = AssessmentFeedback(baseFeedback: Feedback(detailText: detailText, credits: score, type: .MANUAL),
                                              scope: scope,
                                              detail: incompleteFeedback?.detail)
            assessmentResult.addFeedback(feedback: feedback)
            feedbackDelegate?.onFeedbackCreation(feedback)
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
        feedbackDelegate?.onFeedbackDeletion(feedback)
    }
    
    private func addFeedbackSuggestionToFeedbacks(feedbackSuggestion: FeedbackSuggestion) {
        guard var incompleteFeedbackDetail = incompleteFeedback?.detail as? ProgrammingFeedbackDetail else {
            return
        }
        
        let lines = NSRange(location: feedbackSuggestion.fromLine, length: feedbackSuggestion.toLine - feedbackSuggestion.fromLine)
        incompleteFeedbackDetail.lines = lines
        
        let feedback = AssessmentFeedback(
            baseFeedback: Feedback(detailText: feedbackSuggestion.text,
                                   credits: feedbackSuggestion.credits,
                                   type: .MANUAL_UNREFERENCED),
            scope: .inline,
            detail: incompleteFeedbackDetail)
        
        assessmentResult.addFeedback(feedback: feedback)
        feedbackDelegate?.onFeedbackSuggestionSelection(feedbackSuggestion, feedback)
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
                             feedbackDelegate: cvm,
                             title: "Title",
                             isEditing: false,
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
                             ],
                             showSheet: .constant(true)
        )
    }
}
