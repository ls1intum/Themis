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

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Feedback")
                    .font(.body)
                Spacer()
                Button {
                    showEditFeedback = true
                } label: {
                    Image(systemName: "pencil").foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
                .font(.caption)
                Button(role: .destructive) {
                    assessment.feedback.deleteFeedback(id: feedback.id)
                    cvm.deleteInlineHighlight(feedback: feedback)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }
            VStack {
                HStack {
                    Text(feedback.text)
                        .foregroundColor(Color(.systemGray))
                    Spacer()
                    if feedback.credits < 0.0 {
                        Text(String(format: "%.1f", feedback.credits)).foregroundColor(.red)
                    } else if feedback.credits > 0.0 {
                        Text(String(format: "%.1f", feedback.credits)).foregroundColor(.green)
                    } else {
                        Text(String(format: "%.1f", feedback.credits))
                    }
                }
                Text(feedback.detailText)
                    .multilineTextAlignment(.leading)
            }
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2).opacity(0.3))
        }
        .sheet(isPresented: $showEditFeedback) {
            EditFeedbackView(showEditFeedback: $showEditFeedback, feedback: feedback, edit: true, type: feedback.type)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2))
    }
}
