//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Katjana Kosic on 28.11.22.
//

import Foundation
import SwiftUI

struct EditFeedbackView: View {
    @ObservedObject var feedbackModel: FeedbackViewModel
    @State var feedbackText = ""
    @State var score = 0.0
    @Binding var showEditFeedback: Bool
    var feedbackID: Feedback.ID? // if nil add sheet else edit
    let maxScore = Double(10)
    let artemisColor = Color(#colorLiteral(red: 0.20944947, green: 0.2372354269, blue: 0.2806544006, alpha: 1))

    var pickerRange: [Double] {
        Array(stride(from: -1 * maxScore, to: maxScore +  0.5, by: 0.5))
            .sorted { $0 > $1 }
    }
    var title: String {
        feedbackID == nil ? "Add Feedback" : "Edit Feedback"
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                Spacer()
                Button {
                    withAnimation {
                        save()
                        showEditFeedback = false
                    }
                } label: {
                    Text("Save")
                }.font(.title)
                 .disabled(feedbackText.isEmpty)
            }
            HStack {
                TextField("Enter your feedback here", text: $feedbackText, axis: .vertical)
                    .lineLimit(10...40)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(artemisColor, lineWidth: 2))
                Text("Score:")
                    .font(.title)
                    .padding(.leading)
                Picker("Score", selection: $score) {
                    ForEach(pickerRange, id: \.self) { number in
                        if number < 0.0 {
                            Text(String(format: "%.1f", number)).foregroundColor(.red)
                        } else if number > 0.0 {
                            Text(String(format: "%.1f", number)).foregroundColor(.green)
                        } else {
                            Text(String(format: "%.1f", number))
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 150)
            }
            Spacer()
        }
        .onAppear(perform: updateStates)
        .padding()
    }

    private func updateStates() {
        guard let feedback = feedbackModel.getFeedback(id: feedbackID) else {
            return
        }
        self.feedbackText = feedback.feedbackText
        self.score = feedback.score
    }

    private func save() {
        let feedback: Feedback

        if feedbackID == nil {
            feedback = Feedback(feedbackText: feedbackText, score: score)
        } else {
            feedback = Feedback(id: feedbackID, feedbackText: feedbackText, score: score)
        }
        feedbackModel.saveFeedback(feedback: feedback)
        updateStates()
    }

}

struct EditFeedbackView_Previews: PreviewProvider {
    @State static var showEditFeedback = true
    private static let mock: FeedbackViewModel = FeedbackViewModel.mock

    static var previews: some View {
        EditFeedbackView(feedbackModel: mock, showEditFeedback: $showEditFeedback, feedbackID: mock.feedbacks[0].id)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
