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
            List {
                Section(header: HStack {
                    Text("General Feedback")
                        .font(.title3)
                    Spacer()
                    Button {
                        showAddFeedback = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }.padding()) {
                    ForEach(feedbackModel.feedbacks) { feedback in
                        FeedbackCellView(feedbackModel: feedbackModel, feedbackID: feedback.id)
                    }
                    .onDelete(perform: delete(at:))
                }.headerProminence(.increased)
            }
            .listStyle(.sidebar)
            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            EditFeedbackView(feedbackModel: feedbackModel, showEditFeedback: $showAddFeedback, feedbackID: nil)
        }
    }

    private func delete(at indexSet: IndexSet) {
        indexSet
            .map { feedbackModel.feedbacks[$0].id }
            .forEach {
                feedbackModel.deleteFeedback(id: $0)
            }
    }
}

struct GeneralFeedbackCellView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralFeedbackCellView(feedbackModel: FeedbackViewModel.mock)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
