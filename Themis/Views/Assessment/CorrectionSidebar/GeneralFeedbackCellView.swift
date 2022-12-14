//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct GeneralFeedbackListView: View {
    var readOnly: Bool
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel

    @State var showAddFeedback = false

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: HStack {
                    Text("General Feedback")
                    Spacer()
                    Button {
                        showAddFeedback.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(readOnly)
                }.padding()) {
                    ForEach(assessmentResult.generalFeedback) { feedback in
                        FeedbackCellView(feedback: feedback)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete(at:))
                }.headerProminence(.increased)

                Section {
                    ForEach(assessmentResult.inlineFeedback) { feedback in
                        FeedbackCellView(feedback: feedback)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete(at:))
                } header: {
                    HStack {
                        Text("Inline Feedback")
                        Spacer()
                    }.padding()
                }.headerProminence(.increased)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            AddFeedbackView(
                assessmentResult: $assessmentResult,
                cvm: cvm,
                type: .general,
                showSheet: $showAddFeedback
            )
        }
    }

    private func delete(at indexSet: IndexSet) {
        indexSet
            .map { assessmentResult.feedbacks[$0] }
            .forEach {
                assessmentResult.deleteFeedback(id: $0.id)
                cvm.deleteInlineHighlight(feedback: $0)
            }
    }
}

struct GeneralFeedbackListView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel(readOnly: false)
    static let codeEditor = CodeEditorViewModel()
    @State static var assessmentResult = AssessmentResult()

    static var previews: some View {
        GeneralFeedbackListView(
            readOnly: false,
            assessmentResult: $assessmentResult,
            cvm: codeEditor
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
