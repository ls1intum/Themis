//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct FeedbackListView: View {
    var readOnly: Bool
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    
    @State var showAddFeedback = false
    
    var pId: Int?
    var templatePId: Int?
    
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
                            assessmentResult: $assessmentResult,
                            cvm: cvm,
                            feedback: feedback
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
                            assessmentResult: $assessmentResult,
                            cvm: cvm,
                            feedback: feedback
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemBackground))
                        .onTapGesture {
                            if let file = feedback.file, let pId = pId, let templatePId = templatePId {
                                withAnimation {
                                    cvm.openFile(file: file, participationId: pId, templateParticipationId: templatePId)
                                }
                                cvm.scrollUtils.range = cvm.inlineHighlights[file.path]?.first {
                                    $0.id == feedback.id.uuidString
                                }?.range
                            }
                        }
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
                            assessmentResult: $assessmentResult,
                            cvm: cvm,
                            feedback: feedback)
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

struct FeedbackListView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel(readOnly: false)
    static let codeEditor = CodeEditorViewModel()
    @State static var assessmentResult = AssessmentResult()
    
    static var previews: some View {
        FeedbackListView(
            readOnly: false,
            assessmentResult: $assessmentResult,
            cvm: codeEditor
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
