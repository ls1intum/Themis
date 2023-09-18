//
//  CorrectionHelpView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import DesignLibrary
import SharedModels

enum CorrectionSidebarElements {
    case problemStatement, correctionGuidelines, generalFeedback
}

struct CorrectionSidebarView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @State private var correctionSidebarStatus = CorrectionSidebarElements.problemStatement
    
    @Binding var assessmentResult: AssessmentResult
    @ObservedObject var assessmentVM: AssessmentViewModel
    
    weak var feedbackDelegate: (any FeedbackDelegate)?
    
    private var exercise: (any BaseExercise)? {
        // We can't use `assessmentVM.exercise` here because some exercise details would be missing
        assessmentVM.participation?.getExercise()
    }
    
    private var templateParticipationId: Int? {
        assessmentVM.participation?.getExercise(as: ProgrammingExercise.self)?.templateParticipation?.id
    }
    
    var body: some View {
        VStack {
            sideBarElementPicker
            
            ZStack {
                ScrollView {
                    ProblemStatementView(courseId: courseVM.shownCourseID, exerciseId: assessmentVM.exercise.id)
                        .frame(maxHeight: .infinity)
                }
                .padding(.horizontal, problemStatementNeedsPadding ? 15 : 0)
                .opacity(correctionSidebarStatus == .problemStatement ? 1.0 : 0.0001) // 0.0 causes this view to be redrawn
                
                if !assessmentVM.loading {
                    viewForSidebarStatus
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
    
    @ViewBuilder
    private var viewForSidebarStatus: some View {
        switch correctionSidebarStatus {
        case .problemStatement:
            EmptyView() // handled above
        case .correctionGuidelines:
            ScrollView {
                CorrectionGuidelinesCellView(
                    gradingCriteria: exercise?.gradingCriteria ?? [],
                    gradingInstructions: exercise?.gradingInstructions
                )
            }
        case .generalFeedback:
            FeedbackListView(
                assessmentVM: assessmentVM,
                assessmentResult: assessmentResult,
                feedbackDelegate: feedbackDelegate,
                participationId: assessmentVM.participation?.id,
                templateParticipationId: templateParticipationId,
                gradingCriteria: exercise?.gradingCriteria ?? []
            )
        }
    }
    
    private var problemStatementNeedsPadding: Bool {
        guard let exercise else {
            return false
        }
        return type(of: exercise) != ProgrammingExercise.self
    }
}

struct CorrectionSidebarView_Previews: PreviewProvider {
    static let cvm = CodeEditorViewModel()
    @State static var assessmentResult = AssessmentResult()
    @State static var assessmentVM = MockAssessmentViewModel(exercise: Exercise.mockText, readOnly: false)
    
    static var previews: some View {
        CorrectionSidebarView(
            assessmentResult: $assessmentResult,
            assessmentVM: assessmentVM,
            feedbackDelegate: cvm
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
