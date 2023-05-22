import SwiftUI
import SharedModels

// swiftlint:disable closure_body_length


struct AssessmentView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject var codeEditorVM = CodeEditorViewModel()
    @StateObject var paneVM = PaneViewModel()
    
    @State private var showCancelDialog = false
    @State private var showNoSubmissionsAlert = false
    @State private var showStepper = false
    @State private var showSubmitConfirmation = false
    @State private var showNavigationOptions = false
    
    let exercise: Exercise
    
    var submissionId: Int?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            HStack(spacing: 0) {
                if paneVM.showLeftPane {
                    filetreeWithPlaceholder
                        .frame(width: paneVM.dragWidthLeft)
                    
                    LeftGripView(paneVM: paneVM)
                }
                
                CodeEditorView(
                    cvm: codeEditorVM,
                    showFileTree: $paneVM.showLeftPane,
                    readOnly: assessmentVM.readOnly
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Group {
                    RightGripView(paneVM: paneVM)
                    
                    correctionWithPlaceholder
                        .frame(width: paneVM.dragWidthRight)
                }
                .animation(.default, value: paneVM.showRightPane)
            }
            .animation(.default, value: paneVM.showLeftPane)
            
            ToolbarFileTreeToggleButton(paneVM: paneVM)
            .padding(.top, 4)
            .padding(.leading, 13)
        }
        .onAppear {
            assessmentResult.maxPoints = exercise.baseExercise.maxPoints ?? 100
        }
        .onDisappear {
            UndoManager.shared.removeAllActions()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.themisPrimary, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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
                    ToolbarToggleButton(toggleVariable: $codeEditorVM.pencilMode, iconImageSystemName: "hand.draw", inverted: true)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                ToolbarToggleButton(toggleVariable: $showStepper, iconImageSystemName: "textformat.size")
                    .popover(isPresented: $showStepper) {
                        EditorFontSizeStepperView(fontSize: $codeEditorVM.editorFontSize)
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
                    await assessmentVM.initRandomSubmission(exerciseId: exercise.baseExercise.id)
                    if assessmentVM.submission == nil {
                        showNoSubmissionsAlert = true
                    }
                }
            }
            Button("Finish assessing") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .sheet(isPresented: $codeEditorVM.showAddFeedback, onDismiss: {
            codeEditorVM.selectedFeedbackSuggestionId = ""
        }, content: {
            AddFeedbackView(
                assessmentResult: assessmentVM.assessmentResult,
                codeEditorVM: codeEditorVM,
                scope: .inline,
                showSheet: $codeEditorVM.showAddFeedback,
                gradingCriteria: assessmentVM.gradingCriteria,
                feedbackSuggestion: codeEditorVM.selectedFeedbackSuggestion
            )
        })
        .sheet(isPresented: $codeEditorVM.showEditFeedback) {
            if let feedback = assessmentVM.getFeedback(byId: codeEditorVM.feedbackForSelectionId) {
                EditFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    cvm: codeEditorVM,
                    scope: .inline,
                    showSheet: $codeEditorVM.showEditFeedback,
                    idForUpdate: feedback.id,
                    gradingCriteria: assessmentVM.gradingCriteria
                )
            }
        }
        .task {
            if let submissionId, assessmentVM.submission == nil {
                await assessmentVM.getSubmission(id: submissionId)
            }
            if let pId = assessmentVM.participation?.id {
                await codeEditorVM.initFileTree(participationId: pId)
                await codeEditorVM.loadInlineHighlight(assessmentResult: assessmentVM.assessmentResult, participationId: pId)
                await codeEditorVM.getFeedbackSuggestions(participationId: pId, exerciseId: exercise.baseExercise.id)
            }
        }
        .errorAlert(error: $codeEditorVM.error)
        .errorAlert(error: $assessmentVM.error)
    }
    
    var filetreeWithPlaceholder: some View {
        VStack {
            if paneVM.leftPaneAsPlaceholder {
                EmptyView()
            } else {
                FiletreeSidebarView(cvm: codeEditorVM, assessmentVM: assessmentVM)
            }
        }
    }
    
    private var correctionWithPlaceholder: some View {
        VStack {
            if paneVM.rightPaneAsPlaceholder {
                EmptyView()
            } else {
                CorrectionSidebarView(
                    assessmentResult: $assessmentVM.assessmentResult,
                    assessmentVM: assessmentVM,
                    cvm: codeEditorVM,
                    courseId: courseVM.shownCourseID ?? -1
                )
            }
        }
    }
}
