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
    var feedbackID: Feedback.ID

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Feedback")
                    .font(.title2)
                Spacer()
                Button {
                    feedbackModel.deleteFeedback(id: feedbackID)
                } label: {
                    Image(systemName: "trash").foregroundColor(.blue)
                }.font(.title)
            }
            HStack {
                Text(feedbackModel.getFeedbackText(id: feedbackID))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2))
                Spacer()
                Text("Score: " + String(feedbackModel.getFeedbackScore(id: feedbackID)))
            }
        }.padding()
    }
}

struct FeedbackCell_Previews: PreviewProvider {
    private static let mock: FeedbackViewModel = FeedbackViewModel.mock

    static var previews: some View {
        FeedbackCellView(feedbackModel: mock, feedbackID: mock.feedbacks[0].id)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
