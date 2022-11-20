//
//  GeneralFeedbackView.swift
//  feedback2go
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct GeneralFeedbackCellView: View {
    @ObservedObject var feedbackModel: FeedbackViewModel
    @State var showAddFeedback = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("General Feedback")
                    .font(.largeTitle)
                Spacer()
                Button {
                    showAddFeedback = true
                } label: {
                    Image(systemName: "plus")
                }.font(.largeTitle)
            }.padding()
            List(feedbackModel.feedbacks) { feedback in
                FeedbackCellView(feedbackModel: feedbackModel, feedbackID: feedback.id)
            }
            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            AddFeedbackView(feedbackModel: feedbackModel, showAddFeedback: $showAddFeedback)
        }
    }
}

struct GeneralFeedbackCellView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralFeedbackCellView(feedbackModel: FeedbackViewModel.mock)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
