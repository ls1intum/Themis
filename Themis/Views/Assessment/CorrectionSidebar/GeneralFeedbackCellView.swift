//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct GeneralFeedbackCellView: View {
    @EnvironmentObject var assessment: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

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
                    ForEach(assessment.feedback.feedbacks) { feedback in
                        FeedbackCellView(feedback: feedback)
                    }
                    .onDelete(perform: delete(at:))
                }.headerProminence(.increased)
            }
            .listStyle(.sidebar)
            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            EditFeedbackView(showEditFeedback: $showAddFeedback, feedback: nil, edit: false, type: .general)
                .environmentObject(assessment)
                .environmentObject(cvm)
        }
    }
    private func delete(at indexSet: IndexSet) {
        indexSet
            .map { assessment.feedback.feedbacks[$0] }
            .forEach {
                assessment.feedback.deleteFeedback(id: $0.id)
                cvm.deleteInlineHighlight(feedback: $0)
            }
    }
}

struct GeneralFeedbackCellView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralFeedbackCellView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
