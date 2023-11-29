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
    @StateObject var assessmentVM: AssessmentViewModel
    @StateObject var assessmentResult: AssessmentResult
    
    let exercise: Exercise
    
    var submissionId: Int?
    var participationId: Int?
    var resultId: Int?
    var correctionRound: CorrectionRound
    
    @State private var showStepper = false
    @State private var showSubmitConfirmation = false
    @State private var showNoSubmissionsAlert = false
    @State private var showNavigationOptions = false
    
    init(exercise: Exercise,
         submissionId: Int? = nil,
         participationId: Int? = nil,
         resultId: Int? = nil,
         correctionRound: CorrectionRound = .first,
         readOnly: Bool = false) {
        self.exercise = exercise
        self.submissionId = submissionId
        self.participationId = participationId
        self.correctionRound = correctionRound
        self.resultId = resultId
        
        let newAssessmentVM = AssessmentViewModelFactory.assessmentViewModel(for: exercise,
                                                                             submissionId: submissionId,
                                                                             participationId: participationId,
                                                                             resultId: resultId,
                                                                             correctionRound: correctionRound,
                                                                             readOnly: readOnly)
        self._assessmentVM = StateObject(wrappedValue: newAssessmentVM)
        self._assessmentResult = StateObject(wrappedValue: newAssessmentVM.assessmentResult)
    }
    
    var body: some View {
        viewForExerciseType
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.themisPrimary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                assessmentVM.pencilModeDisabled = assessmentVM.readOnly
                assessmentResult.maxPoints = exercise.baseExercise.maxPoints ?? 100
                assessmentResult.allowedBonus = exercise.baseExercise.bonusPoints ?? 0.0
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
                    AssessmentModeSymbol(exerciseTitle: exercise.baseExercise.title,
                                         readOnly: assessmentVM.readOnly,
                                         correctionRound: correctionRound)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                }
                
                if assessmentVM.loading || assessmentVM.isSaving {
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
                    
                    if exercise.supportsReferencedFeedbacks {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ToolbarToggleButton(toggleVariable: $assessmentVM.pencilModeDisabled, iconImageSystemName: "hand.draw", inverted: true)
                                .popoverTip(FeedbackModeTip())
                                .disabled(!assessmentVM.allowsInlineFeedbackOperations)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarToggleButton(toggleVariable: $showStepper, iconImageSystemName: "textformat.size")
                        .popover(isPresented: $showStepper) {
                            EditorFontSizeStepperView(fontSize: $assessmentVM.fontSize)
                        }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomProgressView(progress: assessmentVM.assessmentResult.points,
                                       max: assessmentVM.assessmentResult.maxPoints)
                    
                    ToolbarPointsLabel(assessmentResult: assessmentResult, submission: assessmentVM.submission)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarSaveButton(assessmentVM: assessmentVM)
                        .disabled(assessmentVM.readOnly || assessmentVM.loading || assessmentVM.isSaving)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarToggleButton(toggleVariable: $showSubmitConfirmation, text: "Submit")
                        .buttonStyle(ThemisButtonStyle(color: Color.themisGreen))
                        .disabled(assessmentVM.readOnly || assessmentVM.loading || assessmentVM.isSaving)
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
                        await assessmentVM.submitAssessment()
                        await assessmentVM.notifyThemisML()
                        showNavigationOptions.toggle()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("What do you want to do next?", isPresented: $showNavigationOptions) {
                Button("Next Submission") {
                    Task {
                        assessmentVM.resetForNewAssessment()
                        await assessmentVM.initRandomSubmission()
                        NotificationCenter.default.post(name: Notification.Name.nextAssessmentStarted, object: nil)
                        
                        if assessmentVM.submission == nil {
                            showNoSubmissionsAlert = true
                        }
                    }
                }
                Button("Finish assessing") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .errorAlert(error: $assessmentVM.error, onDismiss: { presentationMode.wrappedValue.dismiss() })
    }
    
    @ViewBuilder
    private var viewForExerciseType: some View {
        switch exercise {
        case .programming:
            ProgrammingAssessmentView(assessmentVM: assessmentVM,
                                      assessmentResult: assessmentResult,
                                      exercise: exercise,
                                      submissionId: submissionId)
        case .text:
            TextAssessmentView(assessmentVM: assessmentVM,
                               assessmentResult: assessmentResult,
                               exercise: exercise,
                               submissionId: submissionId,
                               participationId: participationId,
                               resultId: resultId)
        case .modeling:
            ModelingAssessmentView(assessmentVM: assessmentVM,
                                   assessmentResult: assessmentResult)
        case .fileUpload:
            FileUploadAssessmentView(assessmentVM: assessmentVM,
                                     assessmentResult: assessmentResult)
        default:
            Text("Exercise not supported")
        }
    }
}
// swiftlint:enable closure_body_length
