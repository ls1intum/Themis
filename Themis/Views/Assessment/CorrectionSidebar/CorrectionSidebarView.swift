//
//  CorrectionHelpView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

enum CorrectionSidebarElements {
    case problemStatement, correctionGuidelines, generalFeedback
}

struct CorrectionSidebarView: View {

    @State var correctionSidebarStatus = CorrectionSidebarElements.problemStatement
    @Binding var submission: SubmissionForAssessment?
    var readOnly: Bool
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var umlVM: UMLViewModel

    var body: some View {
        VStack {
            Picker(selection: $correctionSidebarStatus, label: Text("")) {
                Text("Problem")
                    .tag(CorrectionSidebarElements.problemStatement)
                Text("Guidelines")
                    .tag(CorrectionSidebarElements.correctionGuidelines)
                Text("Feedback")
                    .tag(CorrectionSidebarElements.generalFeedback)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            switch correctionSidebarStatus {
            case .problemStatement:
                ScrollView {
                    ProblemStatementCellView(
                        submission: $submission,
                        feedbacks: assessmentResult.feedbacks,
                        umlVM: umlVM
                    )
                }
            case .correctionGuidelines:
                ScrollView {
                    CorrectionGuidelinesCellView(
                        gradingCriteria: submission?.participation.exercise.gradingCriteria ?? [],
                        gradingInstructions: submission?.participation.exercise.gradingInstructions
                    )
                }
            case .generalFeedback:
                FeedbackListView(
                    readOnly: readOnly,
                    assessmentResult: $assessmentResult,
                    cvm: cvm
                )
            }
        }
    }
}

// struct CorrectionSidebarView_Previews: PreviewProvider {
//    static let cvm = CodeEditorViewModel()
//    static let umlVM = UMLViewModel()
//    @State static var assessmentResult = AssessmentResult()
//    @State stati
//
//    static var previews: some View {
//        CorrectionSidebarView(
//            readOnly: false,
//            assessmentResult: $assessmentResult,
//            cvm: cvm,
//            umlVM: umlVM,
//            submission: Submi
//        )
//        .previewInterfaceOrientation(.landscapeLeft)
//    }
// }
