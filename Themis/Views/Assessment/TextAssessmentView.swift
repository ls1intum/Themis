//
//  TextAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 23.05.23.
//

import SwiftUI
import SharedModels

struct TextAssessmentView: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject private var textExerciseRendererVM = TextExerciseRendererViewModel()
    @StateObject private var paneVM = PaneViewModel(mode: .rightOnly)
    @StateObject private var umlVM = UMLViewModel()
    
    let exercise: Exercise
    var submissionId: Int?
    var participationId: Int?
    var resultId: Int?
    
    var body: some View {
        HStack(spacing: 0) {
            TextExerciseRenderer(textExerciseRendererVM: textExerciseRendererVM)
            
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
            textExerciseRendererVM.setup(basedOn: assessmentVM.participation)
        }
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
            if let feedback = assessmentVM.getFeedback(byReference: textExerciseRendererVM.selectedFeedbackForEditingId) {
                EditFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    feedbackDelegate: textExerciseRendererVM,
                    scope: .inline,
                    idForUpdate: feedback.id,
                    gradingCriteria: assessmentVM.gradingCriteria,
                    showSheet: $textExerciseRendererVM.showEditFeedback
                )
            }
        }
        .onChange(of: assessmentVM.fontSize, perform: { textExerciseRendererVM.fontSize = $0 })
        .onChange(of: assessmentVM.pencilMode, perform: { textExerciseRendererVM.pencilMode = $0 })
    }
    
    private var correctionWithPlaceholder: some View {
        VStack {
            CorrectionSidebarView(
                assessmentResult: $assessmentVM.assessmentResult,
                assessmentVM: assessmentVM,
                umlVM: umlVM,
                feedbackDelegate: textExerciseRendererVM
            )
        }
    }
}

struct TextAssessmentView_Previews: PreviewProvider {
    @StateObject private static var assessmentVM = MockAssessmentViewModel(exercise: Exercise.mockText, readOnly: false)
    
    static var previews: some View {
        // swiftlint: disable force_cast
        TextAssessmentView(assessmentVM: assessmentVM,
                           assessmentResult: assessmentVM.assessmentResult as! TextAssessmentResult,
                           exercise: Exercise.mockText)
        .previewInterfaceOrientation(.landscapeRight)
    }
}
