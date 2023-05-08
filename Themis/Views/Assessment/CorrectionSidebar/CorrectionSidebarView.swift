//
//  CorrectionHelpView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import SharedModels

enum CorrectionSidebarElements {
    case problemStatement, correctionGuidelines, generalFeedback
}

struct CorrectionSidebarView: View {

    @State var correctionSidebarStatus = CorrectionSidebarElements.problemStatement
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var umlVM: UMLViewModel
    
    private var exercise: (any BaseExercise)? {
        assessmentVM.participation?.getExercise()
    }
    
    private var templateParticipationId: Int? {
        assessmentVM.participation?.getExercise(as: ProgrammingExercise.self)?.templateParticipation?.id
    }
    
    var body: some View {
        VStack {
            sideBarElementPicker
            
            if !assessmentVM.loading {
                switch correctionSidebarStatus {
                case .problemStatement:
                    ScrollView {
                        ProblemStatementCellView(
                            umlVM: umlVM,
                            problemStatement: exercise?.problemStatement ?? "",
                            feedbacks: assessmentResult.feedbacks
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
                        readOnly: assessmentVM.readOnly,
                        assessmentResult: assessmentResult,
                        cvm: cvm,
                        participationId: assessmentVM.participation?.id,
                        templateParticipationId: templateParticipationId,
                        gradingCriteria: exercise?.gradingCriteria ?? []
                    )
                }
            }
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .background(Color("sidebarBackground"))
    }
    
    private var sideBarElementPicker: some View {
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
    }
}

struct CorrectionSidebarView_Previews: PreviewProvider {
    static let cvm = CodeEditorViewModel()
    static let umlVM = UMLViewModel()
    @State static var assessmentResult = AssessmentResult()
    @State static var assessmentVM = AssessmentViewModel(readOnly: false)
    
    static var previews: some View {
        CorrectionSidebarView(
            assessmentResult: $assessmentResult,
            assessmentVM: assessmentVM,
            cvm: cvm,
            umlVM: umlVM
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
