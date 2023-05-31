//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import SharedModels

struct FeedbackListView: View {
    var readOnly: Bool
    @ObservedObject var assessmentResult: AssessmentResult
    weak var feedbackDelegate: (any FeedbackDelegate)?
    
    @State var showAddFeedback = false
    
    var participationId: Int?
    var templateParticipationId: Int?
    
    let gradingCriteria: [GradingCriterion]
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                generalFeedbackSection
                inlineFeedbackSection
                automaticFeedbackSection
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            Spacer()
        }.sheet(isPresented: $showAddFeedback) {
            AddFeedbackView(
                assessmentResult: assessmentResult,
                feedbackDelegate: feedbackDelegate,
                scope: .general,
                gradingCriteria: gradingCriteria,
                showSheet: $showAddFeedback
            )
        }
    }
    
    private var generalFeedbackSection: some View {
        Section {
            ForEach(assessmentResult.generalFeedback, id: \.self) { feedback in
                FeedbackCellView(
                    readOnly: readOnly,
                    assessmentResult: assessmentResult,
                    feedbackDelegate: feedbackDelegate,
                    feedback: feedback,
                    gradingCriteria: gradingCriteria
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color("sidebarBackground"))
            }
            .onDelete(perform: delete(at:))
        } header: {
            HStack {
                Text("General Feedback")
                Spacer()
                Button {
                    showAddFeedback.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(readOnly)
            }.padding()
        }.headerProminence(.increased)
    }
    
    private var inlineFeedbackSection: some View {
        Section {
            ForEach(assessmentResult.inlineFeedback, id: \.self) { feedback in
                FeedbackCellView(
                    readOnly: readOnly,
                    assessmentResult: assessmentResult,
                    feedbackDelegate: feedbackDelegate,
                    feedback: feedback,
                    participationId: participationId,
                    templateParticipationId: templateParticipationId,
                    gradingCriteria: gradingCriteria
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color("sidebarBackground"))
            }
            .onDelete(perform: delete(at:))
        } header: {
            HStack {
                Text("Inline Feedback")
                Spacer()
            }.padding()
        }.headerProminence(.increased)
    }
    
    private var automaticFeedbackSection: some View {
        Section {
            ForEach(assessmentResult.automaticFeedback, id: \.self) { feedback in
                FeedbackCellView(
                    readOnly: readOnly,
                    assessmentResult: assessmentResult,
                    feedbackDelegate: feedbackDelegate,
                    feedback: feedback,
                    gradingCriteria: gradingCriteria
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color("sidebarBackground"))
            }
        } header: {
            HStack {
                Text("Automatic Feedback")
                Spacer()
            }.padding()
        }.headerProminence(.increased)
    }
    
    private func delete(at indexSet: IndexSet) {
        indexSet
            .map { assessmentResult.feedbacks[$0] }
            .forEach {
                assessmentResult.deleteFeedback(id: $0.id)
                if $0.scope == .inline {
                    feedbackDelegate?.onFeedbackDeletion($0)
                }
            }
    }
}

 struct FeedbackListView_Previews: PreviewProvider {
     static let assessment = AssessmentViewModel(exercise: Exercise.mockText, readOnly: false)
    static let codeEditor = CodeEditorViewModel()
    @State static var assessmentResult = AssessmentResult()
    
    static var previews: some View {
        FeedbackListView(
            readOnly: false,
            assessmentResult: assessmentResult,
            feedbackDelegate: codeEditor,
            gradingCriteria: []
        )
        .onAppear(perform: {
            assessmentResult.addFeedback(feedback: AssessmentFeedback(
                baseFeedback: Feedback(detailText: "Remove this if statement",
                                       credits: 10.0,
                                       type: .MANUAL_UNREFERENCED),
                scope: .general))
            
            assessmentResult.addFeedback(feedback: AssessmentFeedback(
                baseFeedback: Feedback(detailText: "Remove this if statement",
                                       credits: -10.0,
                                       type: .MANUAL_UNREFERENCED),
                scope: .general))
        })
        .previewInterfaceOrientation(.landscapeLeft)
    }
 }
