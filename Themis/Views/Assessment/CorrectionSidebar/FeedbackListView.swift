//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct FeedbackListView: View {
    var readOnly: Bool
    @ObservedObject var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    
    @State var showAddFeedback = false
    
    var participationId: Int?
    var templateParticipationId: Int?
    
    let gradingCriteria: [GradingCriterion]
    
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
                    ForEach(assessmentResult.generalFeedback, id: \.self) { feedback in
                        FeedbackCellView(
                            readOnly: readOnly,
                            assessmentResult: assessmentResult,
                            cvm: cvm,
                            feedback: feedback,
                            gradingCriteria: gradingCriteria
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemBackground))
                    }
                    .onDelete(perform: delete(at:))
                }.headerProminence(.increased)
                
                Section {
                    ForEach(assessmentResult.inlineFeedback, id: \.self) { feedback in
                        FeedbackCellView(
                            readOnly: readOnly,
                            assessmentResult: assessmentResult,
                            cvm: cvm,
                            feedback: feedback,
                            participationId: participationId,
                            templateParticipationId: templateParticipationId,
                            gradingCriteria: gradingCriteria
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemBackground))
                    }
                    .onDelete(perform: delete(at:))
                } header: {
                    HStack {
                        Text("Inline Feedback")
                        Spacer()
                    }.padding()
                }.headerProminence(.increased)
                Section {
                    ForEach(assessmentResult.automaticFeedback, id: \.self) { feedback in
                        FeedbackCellView(
                            readOnly: readOnly,
                            assessmentResult: assessmentResult,
                            cvm: cvm,
                            feedback: feedback,
                            gradingCriteria: gradingCriteria
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemBackground))
                    }
                } header: {
                    HStack {
                        Text("Automatic Feedback")
                        Spacer()
                    }.padding()
                }.headerProminence(.increased)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            AddFeedbackView(
                assessmentResult: assessmentResult,
                cvm: cvm,
                type: .general,
                showSheet: $showAddFeedback,
                gradingCriteria: gradingCriteria
            )
        }
    }
    
    private func delete(at indexSet: IndexSet) {
        indexSet
            .map { assessmentResult.feedbacks[$0] }
            .forEach {
                assessmentResult.deleteFeedback(id: $0.id)
                if $0.type == .inline {
                    cvm.deleteInlineHighlight(feedback: $0)
                }
            }
    }
}

 struct FeedbackListView_Previews: PreviewProvider {
     static let assessment = AssessmentViewModel(readOnly: false)
    static let codeEditor = CodeEditorViewModel()
    @State static var assessmentResult = AssessmentResult()
    
    static var previews: some View {
        FeedbackListView(
            readOnly: false,
            assessmentResult: assessmentResult,
            cvm: codeEditor,
            gradingCriteria: []
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
 }
