//
//  ModelingAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import SwiftUI

import SharedModels

struct ModelingAssessmentView: View {
    @StateObject private var umlRendererVM = UMLRendererViewModel()
    
    var body: some View {
        UMLRenderer(modelString:
                        (Submission.mockModeling.baseSubmission as? ModelingSubmission)?
            .getExercise(as: ModelingExercise.self)?.exampleSolutionModel ?? "nil")
            .task {
//                assessmentVM.participationId = participationId
//                await assessmentVM.initSubmission()
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
    static var previews: some View {
        ModelingAssessmentView()
    }
}
