import SwiftUI
import SharedModels

struct ProgrammingAssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject var codeEditorVM = CodeEditorViewModel()
    @StateObject var paneVM = PaneViewModel()
    
    let exercise: Exercise
    
    var submissionId: Int?
    
    private let didStartNextAssessment = NotificationCenter.default.publisher(for: NSNotification.Name.nextAssessmentStarted)
    
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
                .shows(CodeEditorSkeleton(), if: assessmentVM.loading || codeEditorVM.isLoading)
                
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
        .sheet(isPresented: $codeEditorVM.showAddFeedback, onDismiss: {
            codeEditorVM.selectedFeedbackSuggestionId = ""
        }, content: {
            AddFeedbackView(
                assessmentResult: assessmentVM.assessmentResult,
                feedbackDelegate: codeEditorVM,
                incompleteFeedback: AssessmentFeedback(scope: .inline,
                                                       detail: ProgrammingFeedbackDetail(file: codeEditorVM.selectedFile,
                                                                                         lines: codeEditorVM.selectedSectionParsed?.0,
                                                                                         columns: codeEditorVM.selectedSectionParsed?.1)),
                feedbackSuggestion: codeEditorVM.selectedFeedbackSuggestion,
                scope: .inline,
                gradingCriteria: assessmentVM.gradingCriteria,
                showSheet: $codeEditorVM.showAddFeedback
            )
        })
        .sheet(isPresented: $codeEditorVM.showEditFeedback) {
            if let feedback = assessmentVM.getFeedback(byId: codeEditorVM.selectedFeedbackForEditingId) {
                EditFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    feedbackDelegate: codeEditorVM,
                    scope: .inline,
                    idForUpdate: feedback.id,
                    gradingCriteria: assessmentVM.gradingCriteria,
                    showSheet: $codeEditorVM.showEditFeedback
                )
            }
        }
        .task {
            assessmentVM.pencilModeDisabled = true
            await assessmentVM.initSubmission()
            await codeEditorVM.setup(basedOn: assessmentVM.participation?.id, exercise.baseExercise.id, assessmentVM.assessmentResult)
        }
        .onReceive(didStartNextAssessment, perform: { _ in
            Task {
                await codeEditorVM.setup(basedOn: assessmentVM.participation?.id, exercise.baseExercise.id, assessmentVM.assessmentResult)
            }
        })
        .onChange(of: assessmentVM.pencilModeDisabled) { _, newValue in
            codeEditorVM.pencilModeDisabled = newValue
        }
        .onChange(of: assessmentVM.fontSize) { _, newValue in
            codeEditorVM.editorFontSize = newValue
        }
        .onChange(of: codeEditorVM.allowsInlineFeedbackOperations) { _, newValue in
            assessmentVM.allowsInlineFeedbackOperations = newValue
        }
        .errorAlert(error: $codeEditorVM.error)
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
                    feedbackDelegate: codeEditorVM
                )
            }
        }
    }
}
