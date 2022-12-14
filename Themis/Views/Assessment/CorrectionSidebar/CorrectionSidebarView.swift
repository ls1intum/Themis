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
    var exercise: ExerciseOfSubmission?
    var readOnly: Bool
    @State var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel

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
                        problemStatement: exercise?.problemStatement
                    )
                }
            case .correctionGuidelines:
                ScrollView {
                    CorrectionGuidelinesCellView(
                        gradingCriteria: exercise?.gradingCriteria ?? [],
                        gradingInstructions: exercise?.gradingInstructions
                    )
                }
            case .generalFeedback:
                GeneralFeedbackListView(
                    readOnly: readOnly,
                    assessmentResult: $assessmentResult,
                    cvm: cvm
                )
            }
        }
    }
}

struct CorrectionSidebarView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel(readOnly: false)
    static let cvm = CodeEditorViewModel()

    static var previews: some View {
        CorrectionSidebarView(
            readOnly: false,
            assessmentResult: AssessmentResult(),
            cvm: cvm
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
