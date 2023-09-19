//
//  TextAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 23.05.23.
//

import SwiftUI
import SharedModels
import CodeEditor

struct TextAssessmentView: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject private var textExerciseRendererVM = TextExerciseRendererViewModel()
    @StateObject private var paneVM = PaneViewModel(mode: .rightOnly)
    
    let exercise: Exercise
    var submissionId: Int?
    var participationId: Int?
    var resultId: Int?
    
    private let didStartNextAssessment = NotificationCenter.default.publisher(for: NSNotification.Name.nextAssessmentStarted)
    
    var body: some View {
        HStack(spacing: 0) {
            TextExerciseRenderer(textExerciseRendererVM: textExerciseRendererVM)
                .shows(TextSkeleton(), if: assessmentVM.loading)
            
            Group {
                RightGripView(paneVM: paneVM)
                
                correctionWithPlaceholder
                    .frame(width: paneVM.dragWidthRight)
            }
            .animation(.default, value: paneVM.showRightPane)
        }
        .task {
            assessmentVM.participationId = participationId
            await assessmentVM.initSubmission()
            textExerciseRendererVM.setup(basedOn: assessmentVM.participation, assessmentVM.submission, assessmentResult)
            ensureResultId()
        }
        .onReceive(didStartNextAssessment, perform: { _ in
            guard assessmentVM.submission != nil && assessmentVM.participation != nil else {
                return
            }
            textExerciseRendererVM.setup(basedOn: assessmentVM.participation, assessmentVM.submission, assessmentResult)
            ensureResultId(force: true)
        })
        .onAppear {
            assessmentVM.fontSize = 19.0
        }
        .sheet(isPresented: $textExerciseRendererVM.showAddFeedback, onDismiss: {
            textExerciseRendererVM.selectedFeedbackSuggestionId = ""
        }, content: {
            AddFeedbackView(
                assessmentResult: assessmentVM.assessmentResult,
                feedbackDelegate: textExerciseRendererVM,
                incompleteFeedback: AssessmentFeedback(scope: .inline,
                                                       detail: textExerciseRendererVM.generateIncompleteFeedbackDetail()),
                scope: .inline,
                gradingCriteria: assessmentVM.gradingCriteria,
                showSheet: $textExerciseRendererVM.showAddFeedback
            )
        })
        .sheet(isPresented: $textExerciseRendererVM.showEditFeedback) {
            if let feedback = assessmentVM.getManualFeedback(byId: textExerciseRendererVM.selectedFeedbackForEditingId) {
                // The user tapped on a manual feedback to edit
                EditFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    feedbackDelegate: textExerciseRendererVM,
                    scope: .inline,
                    idForUpdate: feedback.id,
                    gradingCriteria: assessmentVM.gradingCriteria,
                    showSheet: $textExerciseRendererVM.showEditFeedback
                )
            } else if let textAssessmentVM = assessmentVM as? TextAssessmentViewModel,
                      let suggestion = textAssessmentVM.getSuggestion(byAssessmentFeedbackId: textExerciseRendererVM.selectedFeedbackForEditingId) {
                // The user tapped on a feedback suggestion. This is not actually an edit action, but is triggered as one
                AddFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    feedbackDelegate: textExerciseRendererVM,
                    incompleteFeedback: AssessmentFeedback(scope: .inline,
                                                           detail: TextFeedbackDetail(block: suggestion.blockRef.block)),
                    feedbackSuggestion: suggestion,
                    scope: .inline,
                    gradingCriteria: assessmentVM.gradingCriteria,
                    showSheet: $textExerciseRendererVM.showEditFeedback
                )
            }
        }
        .onChange(of: assessmentVM.fontSize, perform: { textExerciseRendererVM.fontSize = $0 })
        .onChange(of: assessmentVM.pencilModeDisabled, perform: { textExerciseRendererVM.pencilModeDisabled = $0 })
    }
    
    private var correctionWithPlaceholder: some View {
        VStack {
            CorrectionSidebarView(
                assessmentResult: $assessmentVM.assessmentResult,
                assessmentVM: assessmentVM,
                feedbackDelegate: textExerciseRendererVM
            )
        }
    }
    
    /// Ensures that the assessmentResult has a non-nil resultId value since it's needed for some operations, such as saving the assessment
    /// - Parameter force: if true, updates the resultId regardless of whether the current value is nil
    private func ensureResultId(force: Bool = false) {
        if force || (assessmentResult as? TextAssessmentResult)?.resultId == nil {
           (assessmentResult as? TextAssessmentResult)?.resultId = assessmentVM.submission?.results?.last?.id
        }
    }
}

struct TextAssessmentView_Previews: PreviewProvider {
    @StateObject private static var assessmentVM = MockAssessmentViewModel(exercise: Exercise.mockText, readOnly: false)
    
    static var previews: some View {
        // swiftlint:disable force_cast
        TextAssessmentView(assessmentVM: assessmentVM,
                           assessmentResult: assessmentVM.assessmentResult as! TextAssessmentResult,
                           exercise: Exercise.mockText)
        .previewInterfaceOrientation(.landscapeRight)
        // swiftlint:enable force_cast
    }
}
