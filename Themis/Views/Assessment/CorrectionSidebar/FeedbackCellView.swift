//
//  FeedbackCell.swift
//  Themis
//
//  Created by Katjana Kosic on 18.11.22.
//

import Foundation
import SwiftUI

struct FeedbackCellView: View {

    var readOnly: Bool
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel

    @State var feedback: AssessmentFeedback
    var editingDisabled: Bool { readOnly || feedback.assessmentType == .AUTOMATIC }

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
    
    var pId: Int?
    var templatePId: Int?
    
    @State var isTapped = false

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
                    assessmentResult.deleteFeedback(id: feedback.id)
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
        .onTapGesture {
            if feedback.type == .inline {
                withAnimation(.linear) {
                    isTapped = true
                }
                if let file = feedback.file, let pId = pId, let templatePId = templatePId {
                    withAnimation {
                        cvm.openFile(file: file, participationId: pId, templateParticipationId: templatePId)
                    }
                    cvm.scrollUtils.range = cvm.inlineHighlights[file.path]?.first {
                        $0.id == feedback.id.uuidString
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
                assessmentResult: $assessmentResult,
                cvm: cvm,
                type: feedback.type,
                showSheet: $showEditFeedback,
                idForUpdate: feedback.id
            )
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(lineWidth: 2)
            .scaleEffect(isTapped ? 1.05 : 1.0))
    }
}
