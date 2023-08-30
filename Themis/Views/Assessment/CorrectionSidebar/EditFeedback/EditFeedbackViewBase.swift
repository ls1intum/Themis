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
    var feedbackSuggestion: (any FeedbackSuggestion)?
    
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
                if feedbackSuggestion != nil {
                    robotSymbol
                }
                
                Text(title ?? "Edit Feedback")
                    .font(.largeTitle)
                
                Spacer()
                
                if isEditing || feedbackSuggestion != nil {
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
    
    private var robotSymbol: some View {
        Image("Robot")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
            .foregroundColor(.themisSecondary)
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
        if let feedbackSuggestion {
            assessmentResult.deleteFeedback(id: feedbackSuggestion.id)
            feedbackDelegate?.onFeedbackSuggestionDiscard(feedbackSuggestion)
        } else if let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) {
            assessmentResult.deleteFeedback(id: feedback.id)
            feedbackDelegate?.onFeedbackDeletion(feedback)
        }
    }
    
    private func addFeedbackSuggestionToFeedbacks(feedbackSuggestion: any FeedbackSuggestion) {
        let feedback = AssessmentFeedback(basedOn: feedbackSuggestion, incompleteFeedback?.detail, detailText, score)
        
        // Try to replace the existing automatic feedback
        let newFeedback = assessmentResult.replace(feedbackWithId: feedbackSuggestion.id, with: feedback)
        
        // No automatic feedback found -> simply add a new feedback for the given suggestion
        if newFeedback == nil {
            assessmentResult.addFeedback(feedback: feedback)
        }
        
        feedbackDelegate?.onFeedbackSuggestionSelection(feedbackSuggestion, feedback)
    }

    private func setStates() {
        if idForUpdate != nil {
            if let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) {
                self.detailText = feedback.baseFeedback.detailText ?? feedback.baseFeedback.text ?? ""
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
