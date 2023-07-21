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
    
    var body: some View {
        UMLRenderer(umlRendererVM: umlRendererVM)
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
}

struct ModelingAssessmentView_Previews: PreviewProvider {
    // swiftlint:disable:next line_length
    @StateObject private static var assessmentVM = MockAssessmentViewModel(exercise: (Submission.mockModeling.baseSubmission.getParticipation()?.exercise)!, readOnly: false)

    static var previews: some View {
        ModelingAssessmentView(assessmentVM: assessmentVM, assessmentResult: assessmentVM.assessmentResult)
    }
}
