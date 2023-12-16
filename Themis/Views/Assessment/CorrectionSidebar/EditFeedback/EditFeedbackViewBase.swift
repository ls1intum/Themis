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
    
    let scope: ThemisFeedbackScope
    let gradingCriteria: [GradingCriterion]
    
    @Binding var showSheet: Bool
    @State private var detailText = ""
    @State private var score = 0.0
    @State private var linkedGradingInstruction: GradingInstruction?
    
    private var isReviewingSuggestion: Bool {
        feedbackSuggestion != nil || assessmentResult.feedbacks.first(where: { idForUpdate == $0.id })?.isSuggested == true
    }
    
    private var isEditing: Bool {
        idForUpdate != nil
    }
    
    private var title: String {
        isReviewingSuggestion ? "Review Suggested Feedback" : (isEditing ? "Edit Feedback" : "Add Feedback")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if isReviewingSuggestion {
                    robotSymbol
                }
                
                Text(title)
                    .font(.largeTitle)
                
                Spacer()
                
                if isEditing || feedbackSuggestion != nil {
                    deleteButton
                }
                
                editOrSaveButton
            }
            
            linkedCriterionInfo
            
            HStack(spacing: 15) {
                textField
                
                ScorePicker(score: $score, maxScore: assessmentResult.maxPoints)
                    .frame(maxWidth: 130)
                    .disabled(linkedGradingInstruction != nil)
            }
            
            Spacer()
            
            gradingCriteriaList
        }
        .padding()
        .onAppear {
            setStates()
        }
        .onChange(of: linkedGradingInstruction) { _, newValue in
            self.score = newValue?.credits ?? 0.0
        }
        .animation(.easeIn(duration: 0.2), value: linkedGradingInstruction)
    }
    
    private var textField: some View {
        TextField("Enter \(linkedGradingInstruction != nil ? "additional" : "your") feedback here", text: $detailText, axis: .vertical)
            .foregroundColor(Color.getTextColor(forCredits: score))
            .submitLabel(.return)
            .lineLimit(10...40)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 2)
                .foregroundColor(.getTextColor(forCredits: score)))
            .background(Color.getBackgroundColor(forCredits: score))
    }
    
    private var gradingCriteriaList: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(gradingCriteria) { gradingCriterion in
                    GradingCriteriaCellView(gradingCriterion: gradingCriterion,
                                            selectedGradingInstruction: $linkedGradingInstruction)
                }
            }
        }
    }
    
    private var robotSymbol: some View {
        Image("SuggestedFeedbackSymbol")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(.feedbackSuggestionColor)
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
    
    @ViewBuilder
    private var linkedCriterionInfo: some View {
        if let instructionFeedback = linkedGradingInstruction?.feedback {
            HStack(alignment: .top, spacing: 5) {
                Image(systemName: "link")
                Text("\(instructionFeedback)")
                
                Spacer()
                
                Button(action: { linkedGradingInstruction = nil }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.themisSecondary)
                        .font(.title2)
                })
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color.getBackgroundColor(forCredits: score))
            }
            .padding(.bottom)
            .foregroundColor(Color.getTextColor(forCredits: score))
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
    
    private func updateFeedback() {
        if let id = idForUpdate,
           let updatedFeedback = assessmentResult.updateFeedback(id: id,
                                                                 detailText: detailText,
                                                                 credits: score,
                                                                 instruction: linkedGradingInstruction) {
            feedbackDelegate?.onFeedbackUpdate(updatedFeedback)
        }
    }
    
    private func createFeedback() {
        if scope == .inline {
            let feedback = AssessmentFeedback(baseFeedback: Feedback(detailText: detailText,
                                                                     credits: score,
                                                                     type: .MANUAL,
                                                                     gradingInstruction: linkedGradingInstruction),
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
            assessmentResult.deleteFeedback(id: feedbackSuggestion.associatedAssessmentFeedbackId ?? UUID())
            feedbackDelegate?.onFeedbackSuggestionDiscard(feedbackSuggestion)
        } else if let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) {
            assessmentResult.deleteFeedback(id: feedback.id)
            feedbackDelegate?.onFeedbackDeletion(feedback)
        }
    }
    
    private func setStates() {
        if idForUpdate != nil {
            if let feedback = assessmentResult.feedbacks.first(where: { idForUpdate == $0.id }) {
                var detailText = feedback.baseFeedback.detailText ?? feedback.baseFeedback.text ?? ""
                // If an instruction is applied, the user can not edit the `text` field
                if feedback.baseFeedback.gradingInstruction != nil {
                    detailText = feedback.baseFeedback.detailText ?? ""
                }
                self.detailText = detailText
                
                self.score = feedback.baseFeedback.credits ?? 0.0
                self.linkedGradingInstruction = feedback.baseFeedback.gradingInstruction
            }
        } else if let feedbackSuggestion {
            self.detailText = feedbackSuggestion.description
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
                             scope: .inline,
                             gradingCriteria: [.mock],
                             showSheet: .constant(true)
        )
    }
}
