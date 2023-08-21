//
//  ModelingAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import SwiftUI

import SharedModels

struct ModelingAssessmentView: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject private var umlRendererVM = UMLRendererViewModel()
    @StateObject private var paneVM = PaneViewModel(mode: .rightOnly)
    @Environment(\.presentationMode) private var presentationMode
    
    private let didStartNextAssessment = NotificationCenter.default.publisher(for: NSNotification.Name.nextAssessmentStarted)
    
    var body: some View {
        HStack(spacing: 0) {
            UMLRenderer(umlRendererVM: umlRendererVM)
            
            Group {
                RightGripView(paneVM: paneVM)
                
                correctionWithPlaceholder
                    .frame(width: paneVM.dragWidthRight)
            }
            .animation(.default, value: paneVM.showRightPane)
        }
        .task {
            await assessmentVM.initSubmission()
            umlRendererVM.setup(basedOn: assessmentVM.submission, assessmentResult)
        }
        .errorAlert(error: $umlRendererVM.error, onDismiss: { presentationMode.wrappedValue.dismiss() })
        .sheet(isPresented: $umlRendererVM.showEditFeedback) {
            if let feedback = assessmentVM.getFeedback(byId: umlRendererVM.selectedFeedbackForEditingId) {
                EditFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    feedbackDelegate: umlRendererVM,
                    scope: .inline,
                    idForUpdate: feedback.id,
                    gradingCriteria: assessmentVM.gradingCriteria,
                    showSheet: $umlRendererVM.showEditFeedback
                )
            }
        }
        .sheet(isPresented: $umlRendererVM.showAddFeedback, onDismiss: {
            umlRendererVM.selectedFeedbackSuggestionId = ""
        }, content: {
            AddFeedbackView(
                assessmentResult: assessmentVM.assessmentResult,
                feedbackDelegate: umlRendererVM,
                incompleteFeedback: AssessmentFeedback(scope: .inline,
                                                       detail: umlRendererVM.generateFeedbackDetail()),
                scope: .inline,
                gradingCriteria: assessmentVM.gradingCriteria,
                showSheet: $umlRendererVM.showAddFeedback
            )
        })
        .onReceive(didStartNextAssessment, perform: { _ in
            guard assessmentVM.submission != nil else {
                return
            }
            umlRendererVM.setup(basedOn: assessmentVM.submission, assessmentResult)
        })
        .onChange(of: umlRendererVM.showAddFeedback) { newValue in
            if !newValue {
                umlRendererVM.selectedElement = nil
            }
        }
        .onChange(of: umlRendererVM.showEditFeedback) { newValue in
            if !newValue {
                umlRendererVM.selectedElement = nil
            }
        }
        .onChange(of: assessmentVM.fontSize, perform: { umlRendererVM.fontSize = $0 })
        .onChange(of: assessmentVM.pencilModeDisabled, perform: {
            umlRendererVM.pencilModeDisabled = $0
            umlRendererVM.selectedElement = nil
        })
    }
    
    private var correctionWithPlaceholder: some View {
        VStack {
            CorrectionSidebarView(
                assessmentResult: $assessmentVM.assessmentResult,
                assessmentVM: assessmentVM,
                feedbackDelegate: umlRendererVM
            )
        }
    }
}

struct ModelingAssessmentView_Previews: PreviewProvider {
    // swiftlint:disable force_unwrapping
    @StateObject private static var assessmentVM = MockAssessmentViewModel(
        exercise: (Submission.mockModeling.baseSubmission.getParticipation()?.exercise)!,
        submission: Submission.mockModeling,
        readOnly: false
    )

    static var previews: some View {
        ModelingAssessmentView(assessmentVM: assessmentVM, assessmentResult: assessmentVM.assessmentResult)
            .environmentObject(CourseViewModel())
    }
    // swiftlint:enable force_unwrapping
}
