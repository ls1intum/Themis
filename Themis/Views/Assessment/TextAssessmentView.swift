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
    @StateObject var paneVM = PaneViewModel(mode: .rightOnly)
    
    let exercise: Exercise
    var submissionId: Int?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            HStack(spacing: 0) {
                Text(assessmentVM.submission?.get(as: TextSubmission.self)?.text ?? "no")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                Group {
                    RightGripView(paneVM: paneVM)
                    
                    correctionWithPlaceholder
                        .frame(width: paneVM.dragWidthRight)
                }
                .animation(.default, value: paneVM.showRightPane)
            }
        }
        .task {
            if let submissionId, assessmentVM.submission == nil {
                await assessmentVM.getSubmission(for: exercise, participationOrSubmissionId: submissionId)
            }
            ThemisUndoManager.shared.removeAllActions()
        }
    }
    
    private var correctionWithPlaceholder: some View {
        VStack {
                Text("Correction Sidebar")
//                CorrectionSidebarView(
//                    assessmentResult: $assessmentVM.assessmentResult,
//                    assessmentVM: assessmentVM
//                )
        }
    }
}

struct TextAssessmentView_Previews: PreviewProvider {
    @StateObject private static var assessmentVM = MockAssessmentViewModel(readOnly: false)
    
    static var previews: some View {
        TextAssessmentView(assessmentVM: assessmentVM,
                           assessmentResult: assessmentVM.assessmentResult,
                           exercise: Exercise.mockText)
        .previewInterfaceOrientation(.landscapeRight)
    }
}
