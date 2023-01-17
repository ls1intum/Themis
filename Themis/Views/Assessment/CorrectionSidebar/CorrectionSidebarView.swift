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
    @Binding var problemStatement: String
    let exercise: ExerciseOfSubmission?
    let readOnly: Bool
    @ObservedObject var assessmentResult: AssessmentResult
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var umlVM: UMLViewModel
    let loading: Bool
    
    var pId: Int?
    var templatePId: Int?

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
            if !loading {
                switch correctionSidebarStatus {
                case .problemStatement:
                    ScrollView {
                        ProblemStatementCellView(
                            problemStatement: $problemStatement,
                            feedbacks: assessmentResult.feedbacks,
                            umlVM: umlVM
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
                    FeedbackListView(
                        readOnly: readOnly,
                        assessmentResult: assessmentResult,
                        cvm: cvm,
                        pId: pId,
                        templatePId: templatePId
                    )
                }
            }
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

 struct CorrectionSidebarView_Previews: PreviewProvider {
    static let cvm = CodeEditorViewModel()
    static let umlVM = UMLViewModel()
    @State static var assessmentResult = AssessmentResult()
    @State static var problemStatement: String = "test"

    static var previews: some View {
        CorrectionSidebarView(
            problemStatement: $problemStatement,
            exercise: nil,
            readOnly: false,
            assessmentResult: assessmentResult,
            cvm: cvm,
            umlVM: umlVM,
            loading: true
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
 }
