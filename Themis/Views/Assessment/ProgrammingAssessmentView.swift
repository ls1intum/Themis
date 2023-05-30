import SwiftUI
import SharedModels

struct ProgrammingAssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject var codeEditorVM = CodeEditorViewModel()
    @StateObject var umlVM = UMLViewModel()
    @StateObject var paneVM = PaneViewModel()
    
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
        .overlay {
            if umlVM.showUMLFullScreen {
                UMLView(umlVM: umlVM)
            }
        }
        .sheet(isPresented: $codeEditorVM.showAddFeedback, onDismiss: {
            codeEditorVM.selectedFeedbackSuggestionId = ""
        }, content: {
            AddFeedbackView(
                assessmentResult: assessmentVM.assessmentResult,
                feedbackDelegate: codeEditorVM,
                incompleteFeedback: AssessmentFeedback(scope: .inline,
                                                       file: codeEditorVM.selectedFile,
                                                       lines: codeEditorVM.selectedSectionParsed?.0,
                                                       columns: codeEditorVM.selectedSectionParsed?.1),
                feedbackSuggestion: codeEditorVM.selectedFeedbackSuggestion,
                scope: .inline,
                gradingCriteria: assessmentVM.gradingCriteria,
                showSheet: $codeEditorVM.showAddFeedback
            )
        })
        .sheet(isPresented: $codeEditorVM.showEditFeedback) {
            if let feedback = assessmentVM.getFeedback(byId: codeEditorVM.feedbackForSelectionId) {
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
            await assessmentVM.initSubmission(for: exercise)
            
            if let pId = assessmentVM.participation?.id {
                await codeEditorVM.initFileTree(participationId: pId)
                await codeEditorVM.loadInlineHighlight(assessmentResult: assessmentVM.assessmentResult, participationId: pId)
                await codeEditorVM.getFeedbackSuggestions(participationId: pId, exerciseId: exercise.baseExercise.id)
            }
            ThemisUndoManager.shared.removeAllActions()
        }
        .onChange(of: assessmentVM.pencilMode, perform: { codeEditorVM.pencilMode = $0 })
        .onChange(of: assessmentVM.fontSize, perform: { codeEditorVM.editorFontSize = $0 })
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
                    umlVM: umlVM,
                    feedbackDelegate: codeEditorVM
                )
            }
        }
    }
}
