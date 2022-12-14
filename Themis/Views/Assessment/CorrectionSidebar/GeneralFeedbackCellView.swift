//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct GeneralFeedbackCellView: View {
    @State var readOnly: Bool
    @State var assessmentResult: AssessmentResult
    @State var cvm: CodeEditorViewModel

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
            EditFeedbackView(
                assessmentResult: assessmentResult,
                cvm: cvm,
                showEditFeedback: $showAddFeedback,
                feedback: nil,
                edit: false,
                type: .general
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

struct GeneralFeedbackCellView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel(readOnly: false)
    static let codeEditor = CodeEditorViewModel()

    static var previews: some View {
        GeneralFeedbackCellView(
            readOnly: false,
            assessmentResult: AssessmentResult(),
            cvm: codeEditor
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
