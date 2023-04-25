//
//  CorrectionHelpView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import DesignLibrary

enum CorrectionSidebarElements {
    case problemStatement, correctionGuidelines, generalFeedback
}

struct CorrectionSidebarView: View {
    @Binding var assessmentResult: AssessmentResult
    
    @ObservedObject var cvm: CodeEditorViewModel
    
    @State private var correctionSidebarStatus = CorrectionSidebarElements.problemStatement
    @State private var problemStatementHeight: CGFloat = 1.0
    @State private var problemStatementRequest: URLRequest
    
    let loading: Bool
    let exercise: ExerciseOfSubmission?
    let readOnly: Bool
    var participationId: Int?
    var templateParticipationId: Int?
    
    init(assessmentResult: Binding<AssessmentResult>,
         exercise: ExerciseOfSubmission?,
         readOnly: Bool,
         cvm: CodeEditorViewModel,
         loading: Bool,
         participationId: Int? = nil,
         templateParticipationId: Int? = nil,
         courseId: Int) {
        self._assessmentResult = assessmentResult
        self.cvm = cvm
        self.loading = loading
        self.exercise = exercise
        self.readOnly = readOnly
        self.participationId = participationId
        self.templateParticipationId = templateParticipationId
        
        
        self._problemStatementRequest = State(wrappedValue: URLRequest(url: URL(string: "/courses/\(courseId)/exercises/\(exercise?.id ?? -1)/problem-statement", relativeTo: RESTController.shared.baseURL)!))
    }
    
    var body: some View {
        VStack {
            sideBarElementPicker
            
            if !loading {
                switch correctionSidebarStatus {
                case .problemStatement:
                    ScrollView {
                        ArtemisWebView(urlRequest: $problemStatementRequest, contentHeight: $problemStatementHeight)
                            .frame(height: problemStatementHeight)
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
                        participationId: participationId,
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
    @State static var assessmentResult = AssessmentResult()
    @State static var problemStatement: String = "test"

    static var previews: some View {
        CorrectionSidebarView(
            assessmentResult: $assessmentResult, exercise: nil,
            readOnly: false,
            cvm: cvm,
            loading: true,
            courseId: 1
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
 }
