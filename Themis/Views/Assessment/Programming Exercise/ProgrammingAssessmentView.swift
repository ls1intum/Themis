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
    
    @State private var repositorySelection = RepositoryType.student
    
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
            await assessmentVM.initSubmission()
            
            if let pId = assessmentVM.participation?.id {
                await codeEditorVM.initFileTree(participationId: pId, repositoryType: .student)
                await codeEditorVM.loadInlineHighlightsIfEmpty(assessmentResult: assessmentVM.assessmentResult, participationId: pId)
                await codeEditorVM.getFeedbackSuggestions(participationId: pId, exerciseId: exercise.baseExercise.id)
            }
            ThemisUndoManager.shared.removeAllActions()
        }
        .onChange(of: assessmentVM.pencilModeDisabled, perform: { codeEditorVM.pencilModeDisabled = $0 })
        .onChange(of: assessmentVM.allowsInlineFeedbackOperations, perform: { codeEditorVM.allowsInlineFeedbackOperations = $0 })
        .onChange(of: assessmentVM.fontSize, perform: { codeEditorVM.editorFontSize = $0 })
        .errorAlert(error: $codeEditorVM.error)
    }
    
    var filetreeWithPlaceholder: some View {
        VStack {
            if paneVM.leftPaneAsPlaceholder {
                EmptyView()
            } else {
                FiletreeSidebarView(cvm: codeEditorVM, assessmentVM: assessmentVM, repositorySelection: $repositorySelection)
                    .onChange(of: repositorySelection) { newRepositoryType in
                        if let participationId = assessmentVM.participationId(for: newRepositoryType) {
                            Task {
                                await codeEditorVM.initFileTree(participationId: participationId, repositoryType: newRepositoryType)
                                assessmentVM.allowsInlineFeedbackOperations = (newRepositoryType == .student)
                                
                                if newRepositoryType == .student {
                                    await codeEditorVM.loadInlineHighlightsIfEmpty(assessmentResult: assessmentVM.assessmentResult,
                                                                                   participationId: participationId)
                                } else {
                                    assessmentVM.pencilModeDisabled = true
                                }
                            }
                        }
                    }
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
