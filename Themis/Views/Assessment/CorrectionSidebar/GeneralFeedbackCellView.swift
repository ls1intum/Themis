//
//  GeneralFeedbackView.swift
//  Themis
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
                Text("Add General Feedback")
                    .font(.title3)
                Spacer()
                Button {
                    showAddFeedback = true
                } label: {
                    Image(systemName: "plus")
                }.font(.title3)
            }.padding()

            List {
                Section(header: Text("General")) {
                    ForEach(feedbackModel.generalFeedbacks) { feedback in
                        FeedbackCellView(feedbackModel: feedbackModel, feedbackID: feedback.id)
                    }
                }
                Section(header: Text("Inline")) {
                    ForEach(feedbackModel.inlineFeedbacks) { feedback in
                        FeedbackCellView(feedbackModel: feedbackModel, feedbackID: feedback.id)
                    }
                }
            }
            .listStyle(.plain)

            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            AddFeedbackView(feedbackModel: feedbackModel, showAddFeedback: $showAddFeedback, type: .general)
        }
    }
}

struct GeneralFeedbackCellView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralFeedbackCellView(feedbackModel: FeedbackViewModel.mock)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
