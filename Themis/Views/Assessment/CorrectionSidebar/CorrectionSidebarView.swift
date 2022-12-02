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
                    ProblemStatementCellView()
                }
            case .correctionGuidelines:
                ScrollView {
                    CorrectionGuidelinesCellView()
                }
            case .generalFeedback:
                GeneralFeedbackCellView()
            }
        }
    }
}

struct CorrectionSidebarView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel()
    static let codeEditor = CodeEditorViewModel()

    static var previews: some View {
        CorrectionSidebarView()
            .environmentObject(assessment)
            .environmentObject(codeEditor)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
