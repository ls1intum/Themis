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

    var readOnly: Bool
    var assessmentResult: AssessmentResult
    @ObservedObject var codeEditorVM: CodeEditorViewModel

    @State var feedback: AssessmentFeedback
    private var editingDisabled: Bool { readOnly || !codeEditorVM.allowsInlineFeedbackOperations }
    private var tapGestureDisabled: Bool { feedback.scope != .inline || !codeEditorVM.allowsInlineFeedbackOperations }
    
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
                if let file = feedback.file, let participationId = participationId, let templateParticipationId = templateParticipationId {
                    withAnimation {
                        codeEditorVM.openFile(file: file, participationId: participationId, templateParticipationId: templateParticipationId)
                    }
                    codeEditorVM.scrollUtils.range = codeEditorVM.inlineHighlights[file.path]?.first {
                        $0.id == "\(feedback.id)"
                    }?.range
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear) {
                        isTapped = false
                    }
                }
            }
        }
        .scaleEffect(isTapped ? 1.05 : 1.0)
        .sheet(isPresented: $showEditFeedback) {
            EditFeedbackView(
                assessmentResult: assessmentResult,
                cvm: codeEditorVM,
                scope: feedback.scope,
                showSheet: $showEditFeedback,
                idForUpdate: feedback.id,
                gradingCriteria: gradingCriteria
            )
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 1)
            .foregroundColor(.getTextColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
            .scaleEffect(isTapped ? 1.05 : 1.0))
        .background(Color.getBackgroundColor(forCredits: feedback.baseFeedback.credits ?? 0.0))
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
