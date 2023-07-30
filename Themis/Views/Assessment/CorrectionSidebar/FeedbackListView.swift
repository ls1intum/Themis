//
//  GeneralFeedbackView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import SharedModels
import DesignLibrary

struct FeedbackListView: View {
    var readOnly: Bool
    var allowsInlineFeedbackOperations: Bool
    @ObservedObject var assessmentResult: AssessmentResult
    weak var feedbackDelegate: (any FeedbackDelegate)?
    
    @State var showAddFeedback = false
    
    var participationId: Int?
    var templateParticipationId: Int?
    let gradingCriteria: [GradingCriterion]
    
    private var isFeedbackCreationDisabled: Bool { readOnly || !allowsInlineFeedbackOperations }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                athenaHintBox
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
    
    @ViewBuilder
    private var athenaHintBox: some View {
        if type(of: assessmentResult) == ModelingAssessmentResult.self
            && !assessmentResult.automaticFeedback.isEmpty {
            // swiftlint:disable line_length
            ArtemisHintBox(text: "Congratulations! To save you some time, parts of this model were already assessed automatically. Please review the automatic assessment and assess the rest of the model afterwards. By submitting the assessment you also confirm the automatic assessment. Please be aware that you are responsible for the whole assessment.")
            // swiftlint:enable line_length
        }
    }
    
    private var generalFeedbackSection: some View {
        Section {
            ForEach(assessmentResult.generalFeedback, id: \.self) { feedback in
                FeedbackCellView(
                    allowsInlineFeedbackOperations: allowsInlineFeedbackOperations,
                    readOnly: readOnly,
                    assessmentResult: assessmentResult,
                    feedbackDelegate: feedbackDelegate,
                    feedback: feedback,
                    gradingCriteria: gradingCriteria
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color("sidebarBackground"))
            }
            .onDelete { delete(at: $0, in: assessmentResult.generalFeedback) }
        } header: {
            HStack {
                Text("General Feedback")
                Spacer()
                Button {
                    showAddFeedback.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(isFeedbackCreationDisabled)
            }.padding()
        }.headerProminence(.increased)
    }
    
    private var inlineFeedbackSection: some View {
        Section {
            ForEach(assessmentResult.inlineFeedback, id: \.self) { feedback in
                FeedbackCellView(
                    allowsInlineFeedbackOperations: allowsInlineFeedbackOperations,
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
            .onDelete { delete(at: $0, in: assessmentResult.inlineFeedback) }
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
                    allowsInlineFeedbackOperations: allowsInlineFeedbackOperations,
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
    
    private func delete(at indexSet: IndexSet, in feedbackArray: [AssessmentFeedback]) {
        indexSet
            .map { feedbackArray[$0] }
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
            allowsInlineFeedbackOperations: true,
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
