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
    @State var problemStatement: String?
    @EnvironmentObject var avm: AssessmentViewModel
    @State var cvm: CodeEditorViewModel

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
                        problemStatement: problemStatement
                    )
                }
            case .correctionGuidelines:
                ScrollView {
                    CorrectionGuidelinesCellView()
                }
            case .generalFeedback:
                GeneralFeedbackCellView(
                    readOnly: avm.readOnly,
                    assessmentResult: avm.feedback,
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
            cvm: cvm
        )
            .environmentObject(assessment)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
