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

    @State var showEditFeedback = false
    let artemisColor = Color(#colorLiteral(red: 0.20944947, green: 0.2372354269, blue: 0.2806544006, alpha: 1))
    var feedbackColor: Color {
        if feedback.credits < 0.0 {
            return Color(.systemRed)
        } else if feedback.credits > 0.0 {
            return Color(.systemGreen)
        } else {
            return Color(.systemBackground)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(feedback.text.isEmpty ? "Feedback" : feedback.text)
                Spacer()
                Button {
                    showEditFeedback = true
                } label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 15, height: 15)
                    }
                .buttonStyle(.borderless)
                .font(.caption)
                Button(role: .destructive) {
                    assessment.feedback.deleteFeedback(id: feedback.id)
                    cvm.deleteInlineHighlight(feedback: feedback)
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }
            Divider()
                .frame(maxWidth: .infinity)
            HStack {
                Text(feedback.detailText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(format: "%.1f", feedback.credits))
                    .foregroundColor(feedbackColor)
            }
        }
        .sheet(isPresented: $showEditFeedback) {
            EditFeedbackView(showEditFeedback: $showEditFeedback, feedback: feedback, edit: true, type: feedback.type)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(lineWidth: 2))
    }
}
