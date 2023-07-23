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
            umlRendererVM.setup(basedOn: assessmentVM.submission)
        }
        //            .sheet(isPresented: $umlRendererVM.showAddFeedback, onDismiss: {
        //                umlRendererVM.selectedFeedbackSuggestionId = ""
        //            }, content: {
        //                AddFeedbackView(
        //                    assessmentResult: assessmentVM.assessmentResult,
        //                    feedbackDelegate: textExerciseRendererVM,
        //                    incompleteFeedback: AssessmentFeedback(scope: .inline,
        //                                                           detail: textExerciseRendererVM.generateIncompleteFeedbackDetail()),
        //                    scope: .inline,
        //                    gradingCriteria: assessmentVM.gradingCriteria,
        //                    showSheet: $textExerciseRendererVM.showAddFeedback
        //                )
        //            })
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
