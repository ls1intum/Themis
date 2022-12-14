//
//  FeedbackCell.swift
//  Themis
//
//  Created by Katjana Kosic on 18.11.22.
//

import Foundation
import SwiftUI

struct FeedbackCellView: View {

    @EnvironmentObject var assessment: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    let feedback: AssessmentFeedback
    var editingDisabled: Bool { assessment.readOnly || feedback.assessmentType == .AUTOMATIC }

    @State var showEditFeedback = false
    var feedbackColor: Color {
        if feedback.credits < 0.0 {
            return Color(.systemRed)
        } else if feedback.credits > 0.0 {
            return Color(.systemGreen)
        } else {
            return Color(.label)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(feedback.text ?? "Feedback")
                Spacer()
                Button {
                    showEditFeedback = true
                } label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                .disabled(editingDisabled)
                .buttonStyle(.borderless)
                .font(.caption)
                Button(role: .destructive) {
                    assessment.assessmentResult.deleteFeedback(id: feedback.id)
                    cvm.deleteInlineHighlight(feedback: feedback)
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                .disabled(editingDisabled)
                .buttonStyle(.borderless)
                .font(.caption)
            }
            Divider()
                .frame(maxWidth: .infinity)
            HStack {
                Text(feedback.detailText ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(format: "%.1f", feedback.credits))
                    .foregroundColor(feedbackColor)
            }
        }
        .sheet(isPresented: $showEditFeedback) {
            EditFeedbackView(
                assessmentResult: assessment.assessmentResult,
                cvm: cvm,
                showEditFeedback: $showEditFeedback,
                feedback: feedback,
                edit: true,
                type: feedback.type
            )
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(lineWidth: 2))
    }
}
