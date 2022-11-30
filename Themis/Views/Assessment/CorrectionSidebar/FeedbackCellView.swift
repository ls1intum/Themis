//
//  FeedbackCell.swift
//  Themis
//
//  Created by Katjana Kosic on 18.11.22.
//

import Foundation
import SwiftUI

struct FeedbackCellView: View {
    @ObservedObject var feedbackModel: FeedbackViewModel
    @State var showEditFeedback = false
    var feedbackID: Feedback.ID
    let artemisColor = Color(#colorLiteral(red: 0.20944947, green: 0.2372354269, blue: 0.2806544006, alpha: 1))

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
                    feedbackModel.deleteFeedback(id: feedbackID)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }
            HStack {
                Text(feedbackModel.getFeedbackText(id: feedbackID))
                    .font(.caption)
                Spacer()
                if feedbackModel.getFeedbackScore(id: feedbackID) < 0.0 {
                    Text(String(feedbackModel.getFeedbackScore(id: feedbackID))).foregroundColor(.red)
                } else if feedbackModel.getFeedbackScore(id: feedbackID) > 0.0 {
                    Text(String(feedbackModel.getFeedbackScore(id: feedbackID))).foregroundColor(.green)
                } else {
                    Text(String(feedbackModel.getFeedbackScore(id: feedbackID)))
                }
            }.padding(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(artemisColor, lineWidth: 2).opacity(0.3))
        }
        .sheet(isPresented: $showEditFeedback) {
            EditFeedbackView(feedbackModel: feedbackModel, showEditFeedback: $showEditFeedback, feedbackID: feedbackID)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(artemisColor, lineWidth: 2))
    }
}

struct FeedbackCell_Previews: PreviewProvider {
    private static let mock: FeedbackViewModel = FeedbackViewModel.mock

    static var previews: some View {
        FeedbackCellView(feedbackModel: mock, feedbackID: mock.feedbacks[0].id)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
