//
//  AssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 23.05.23.
//
// swiftlint:disable closure_body_length

import SwiftUI
import SharedModels

struct AssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    
    let exercise: Exercise
    
    var submissionId: Int?
    
    @State private var showStepper = false
    @State private var showSubmitConfirmation = false
    @State private var showNoSubmissionsAlert = false
    @State private var showNavigationOptions = false
        
    var body: some View {
        viewForExerciseType
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.themisPrimary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                assessmentResult.maxPoints = exercise.baseExercise.maxPoints ?? 100
            }
            .onDisappear {
                ThemisUndoManager.shared.removeAllActions()
                assessmentVM.resetToolbarProperties()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ToolbarCancelButton(assessmentVM: assessmentVM, presentationMode: presentationMode)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    AssessmentModeSymbol(exerciseTitle: exercise.baseExercise.title, readOnly: assessmentVM.readOnly)
                }
                
                if assessmentVM.loading {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ProgressView()
                            .frame(width: 20)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                
                if !assessmentVM.readOnly {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ToolbarUndoButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        ToolbarRedoButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ToolbarToggleButton(toggleVariable: $assessmentVM.pencilMode, iconImageSystemName: "hand.draw", inverted: true)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarToggleButton(toggleVariable: $showStepper, iconImageSystemName: "textformat.size")
                        .popover(isPresented: $showStepper) {
                            EditorFontSizeStepperView(fontSize: $assessmentVM.fontSize)
                        }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomProgressView(progress: assessmentVM.assessmentResult.score,
                                       max: assessmentVM.assessmentResult.maxPoints)
                    
                    ToolbarPointsLabel(assessmentResult: assessmentResult, submission: assessmentVM.submission)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarSaveButton(assessmentVM: assessmentVM)
                        .disabled(assessmentVM.readOnly || assessmentVM.loading)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarToggleButton(toggleVariable: $showSubmitConfirmation, text: "Submit")
                        .buttonStyle(ThemisButtonStyle(color: Color.themisGreen))
                        .disabled(assessmentVM.readOnly || assessmentVM.loading)
                }
            }
            .alert("No more submissions to assess.", isPresented: $showNoSubmissionsAlert) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .alert("Are you sure you want to submit your assessment?", isPresented: $showSubmitConfirmation) {
                Button("Yes") {
                    Task {
                        await assessmentVM.sendAssessment(submit: true)
                        await assessmentVM.notifyThemisML(exerciseId: exercise.baseExercise.id)
                        showNavigationOptions.toggle()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("What do you want to do next?", isPresented: $showNavigationOptions) {
                Button("Next Submission") {
                    Task {
                        await assessmentVM.initRandomSubmission(for: exercise)
                        if assessmentVM.submission == nil {
                            showNoSubmissionsAlert = true
                        }
                    }
                }
                Button("Finish assessing") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
    
    @ViewBuilder
    private var viewForExerciseType: some View {
        switch exercise {
        case .programming(exercise: _):
            ProgrammingAssessmentView(assessmentVM: assessmentVM,
                                      assessmentResult: assessmentResult,
                                      exercise: exercise,
                                      submissionId: submissionId)
        case .text(exercise: _):
            TextAssessmentView(assessmentVM: assessmentVM,
                               assessmentResult: assessmentResult,
                               exercise: exercise,
                               submissionId: submissionId)
        default:
            Text("Exercise not supported")
        }
    }
}
