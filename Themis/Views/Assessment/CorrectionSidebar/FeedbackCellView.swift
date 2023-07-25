//
//  FeedbackCell.swift
//  Themis
//
//  Created by Katjana Kosic on 18.11.22.
//

import Foundation
import SwiftUI
import SharedModels

struct FeedbackCellView: View {
    var allowsInlineFeedbackOperations: Bool
    var readOnly: Bool
    var assessmentResult: AssessmentResult
    weak var feedbackDelegate: (any FeedbackDelegate)?

    @State var feedback: AssessmentFeedback
    private var editingDisabled: Bool { readOnly || !allowsInlineFeedbackOperations }
    private var tapGestureDisabled: Bool { feedback.scope != .inline || !allowsInlineFeedbackOperations }
    
    @State var showEditFeedback = false
    
    var participationId: Int?
    var templateParticipationId: Int?
    
    @State var isTapped = false
    
    let gradingCriteria: [GradingCriterion]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(feedback.baseFeedback.text ?? "Feedback")
                    .foregroundColor(.getTextColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
                
                Spacer()
                
                editButton
            }
            
            Divider()
                .frame(maxWidth: .infinity)
            
            HStack {
                Text(feedback.baseFeedback.detailText ?? "")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.getTextColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
                pointLabel
            }
        }
        .onTapGesture {
            if !tapGestureDisabled {
                withAnimation(.linear) {
                    isTapped = true
                }
                
                feedbackDelegate?.onFeedbackCellTap(feedback, participationId: participationId, templateParticipationId: templateParticipationId)
                
                withAnimation(.linear(duration: 0.3)) {
                    isTapped = false
                }
            }
        }
        .sheet(isPresented: $showEditFeedback) {
            EditFeedbackView(
                assessmentResult: assessmentResult,
                feedbackDelegate: feedbackDelegate,
                scope: feedback.scope,
                idForUpdate: feedback.id,
                gradingCriteria: gradingCriteria,
                showSheet: $showEditFeedback
            )
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 1)
            .foregroundColor(.getTextColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
        )
        .background(Color.getBackgroundColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
        .scaleEffect(isTapped ? 1.05 : 1.0)
    }
    
    private var pointLabel: some View {
        Text(String(format: "%.1f", feedback.baseFeedback.credits ?? 0.0) + "P")
            .font(.headline)
            .foregroundColor(.white)
            .padding(7)
            .background(Color.getPointsBackgroundColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
            .cornerRadius(5)
    }
    
    private var editButton: some View {
        Button {
            showEditFeedback = true
        } label: {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 18, height: 18)
        }
        .buttonStyle(ThemisButtonStyle(horizontalPadding: 8))
        .font(.caption)
        .disabled(editingDisabled)
        .isHidden(feedback.baseFeedback.type?.isAutomatic ?? false)
    }
}
