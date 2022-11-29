//
//  FeedbackCell.swift
//  Themis
//
//  Created by Katjana Kosic on 18.11.22.
//

import Foundation
import SwiftUI

struct AddFeedbackView: View {
    @ObservedObject var feedbackModel: FeedbackViewModel
    @State var feedbackText = ""
    @State var score = 0.0
    @Binding var showAddFeedback: Bool
    let maxScore = Double(10)
    var pickerRange: [Double] {
        Array(stride(from: -1 * maxScore, to: maxScore +  0.5, by: 0.5))
    }
    var type: FeedbackType
    var lineReference: Int?
    var file: Node?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Feedback")
                    .font(.largeTitle)
                Spacer()
                Button {
                    feedbackModel.addFeedback(feedbackText: feedbackText, score: score, type: type, lineReference: lineReference, file: file)
                    showAddFeedback = false
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
                        .stroke(Color.blue, lineWidth: 2))
                Text("Score:")
                    .font(.title)
                    .padding(.leading)
                Picker("Score", selection: $score) {
                    ForEach(pickerRange, id: \.self) { number in
                        Text(String(format: "%.1f", number))
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 150)
            }
            Spacer()
        }.padding()
    }
}

struct AddFeedbackView_Previews: PreviewProvider {
    @State static var showAddFeedback = true

    static var previews: some View {
        AddFeedbackView(feedbackModel: FeedbackViewModel.mock, showAddFeedback: $showAddFeedback, type: .general)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
