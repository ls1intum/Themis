import SwiftUI
import SharedModels

// swiftlint:disable type_body_length
// swiftlint:disable closure_body_length
// swiftlint:disable line_length


struct AssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var assessmentVM: AssessmentViewModel
    @StateObject var cvm = CodeEditorViewModel()
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject var umlVM = UMLViewModel()
    
    @State var showFileTree = true
    @State var showCorrectionSidebar = false
    @State private var dragWidthLeft: CGFloat = 0.2 * UIScreen.main.bounds.size.width
    @State private var dragWidthRight: CGFloat = 0
    @State private var correctionAsPlaceholder = true
    @State private var filetreeAsPlaceholder = false
    @State private var showCancelDialog = false
    @State var showNoSubmissionsAlert = false
    @State var showStepper = false
    @State var showSubmitConfirmation = false
    @State var showNavigationOptions = false
    
    private let minRightSnapWidth: CGFloat = 185
    private let minLeftSnapWidth: CGFloat = 150
    
    let exercise: Exercise
    
    var submissionId: Int?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            HStack(spacing: 0) {
                if showFileTree {
                    filetreeWithPlaceholder
                        .frame(width: dragWidthLeft)
                    leftGrip
                        .edgesIgnoringSafeArea(.bottom)
                }
                CodeEditorView(
                    cvm: cvm,
                    showFileTree: $showFileTree,
                    readOnly: assessmentVM.readOnly
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Group {
                    rightGrip
                        .edgesIgnoringSafeArea(.bottom)
                    correctionWithPlaceholder
                        .frame(width: dragWidthRight)
                }
                .animation(.default, value: showCorrectionSidebar)
            }
            .animation(.default, value: showFileTree)
            Button {
                showFileTree.toggle()
                filetreeAsPlaceholder = false
                if dragWidthLeft < minLeftSnapWidth {
                    dragWidthLeft = minLeftSnapWidth
                } else if dragWidthLeft > 0.4 * UIScreen.main.bounds.size.width {
                    dragWidthLeft = 0.4 * UIScreen.main.bounds.size.width
                }
            } label: {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 23))
            }
            .padding(.top, 4)
            .padding(.leading, 13)
        }
        .onAppear {
            assessmentResult.maxPoints = exercise.baseExercise.maxPoints ?? 100
        }
        .onDisappear {
            assessmentVM.assessmentResult.undoManager.removeAllActions()
        }
        .overlay {
            if umlVM.showUMLFullScreen {
                UMLView(umlVM: umlVM)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.themisPrimary, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if assessmentVM.readOnly {
                    Button {
                        Task {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Cancel")
                        }
                    }
                    .foregroundColor(.white)
                } else {
                    Button {
                        Task {
                            showCancelDialog.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Cancel")
                        }
                        .foregroundColor(.white)
                    }
                    .confirmationDialog("Cancel Assessment", isPresented: $showCancelDialog) {
                        Button("Save") {
                            Task {
                                if let pId = assessmentVM.submission?.participation?.id {
                                    await assessmentVM.sendAssessment(participationId: pId, submit: false)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        Button("Delete", role: .destructive) {
                            Task {
                                if let id = assessmentVM.submission?.id {
                                    await assessmentVM.cancelAssessment(submissionId: id)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } message: {
                        Text("""
                             Either discard the assessment \
                             and release the lock (recommended) \
                             or keep the lock and save the assessment without submitting it.
                             """)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(alignment: .center) {
                    Text(exercise.baseExercise.title ?? "")
                        .bold()
                        .font(.title)
                    Image(systemName: assessmentVM.readOnly ? "eyeglasses" : "pencil.and.outline")
                        .font(.title3)
                }
                .foregroundColor(.white)
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
                    Button {
                        withAnimation(.easeInOut) {
                            assessmentVM.assessmentResult.undo()
                        }
                    } label: {
                        let undoIconColor: Color = !assessmentVM.assessmentResult.canUndo() ? .gray : .white
                        Image(systemName: "arrow.uturn.backward")
                            .foregroundStyle(undoIconColor)
                    }
                    .disabled(!assessmentVM.assessmentResult.canUndo())
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut) {
                            assessmentVM.assessmentResult.redo()
                        }
                    } label: {
                        let redoIconColor: Color = !assessmentVM.assessmentResult.canRedo() ? .gray : .white
                        Image(systemName: "arrow.uturn.forward")
                            .foregroundStyle(redoIconColor)
                    }
                    .disabled(!assessmentVM.assessmentResult.canRedo())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cvm.pencilMode.toggle()
                    } label: {
                        let iconDrawingColor: Color = cvm.pencilMode ? .gray : .yellow
                        Image(systemName: "hand.draw")
                            .symbolRenderingMode(.palette)
                            .foregroundColor(iconDrawingColor)
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showStepper.toggle()
                } label: {
                    let iconColor: Color = showStepper ? .yellow : .gray
                    Image(systemName: "textformat.size")
                        .foregroundColor(iconColor)
                }
                .popover(isPresented: $showStepper) {
                    EditorFontSizeStepperView(fontSize: $cvm.editorFontSize)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                CustomProgressView(
                    progress: assessmentVM.assessmentResult.score,
                    max: (assessmentVM.submission?.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise.maxPoints ?? 0
                )
                pointsDisplay
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if let pId = assessmentVM.submission?.participation?.id {
                            await assessmentVM.sendAssessment(participationId: pId, submit: false)
                        }
                    }
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                }
                .buttonStyle(ThemisButtonStyle(iconImageName: "saveIcon"))
                .disabled(assessmentVM.readOnly || assessmentVM.loading)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSubmitConfirmation.toggle()
                } label: {
                    Text("Submit")
                        .foregroundColor(.white)
                }
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
                    if let pId = assessmentVM.submission?.participation?.id {
                        await assessmentVM.sendAssessment(participationId: pId, submit: true)
                        await assessmentVM.notifyThemisML(participationId: pId, exerciseId: exercise.baseExercise.id)
                    }
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
        .sheet(isPresented: $cvm.showAddFeedback, onDismiss: {
            cvm.selectedFeedbackSuggestionId = ""
        }, content: {
            AddFeedbackView(
                assessmentResult: assessmentVM.assessmentResult,
                cvm: cvm,
                scope: .inline,
                showSheet: $cvm.showAddFeedback,
                file: cvm.selectedFile,
                gradingCriteria: (assessmentVM.submission?.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise.gradingCriteria ?? [],
                feedbackSuggestion: cvm.feedbackSuggestions.first { "\($0.id)" == cvm.selectedFeedbackSuggestionId }
            )
        })
        .sheet(isPresented: $cvm.showEditFeedback) {
            if let feedback = assessmentVM.assessmentResult.feedbacks.first(where: { "\($0.id)" == cvm.feedbackForSelectionId }) {
                EditFeedbackView(
                    assessmentResult: assessmentVM.assessmentResult,
                    cvm: cvm,
                    scope: .inline,
                    showSheet: $cvm.showEditFeedback,
                    idForUpdate: feedback.id,
                    gradingCriteria: (assessmentVM.submission?.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise.gradingCriteria ?? []
                )
            }
        }
        .task {
            if let submissionId, assessmentVM.submission == nil {
                await assessmentVM.getSubmission(id: submissionId)
            }
            if let pId = assessmentVM.submission?.participation?.id {
                await cvm.initFileTree(participationId: pId)
                await cvm.loadInlineHighlight(assessmentResult: assessmentVM.assessmentResult, participationId: pId)
                await cvm.getFeedbackSuggestions(participationId: pId, exerciseId: exercise.baseExercise.id)
            }
        }
        .errorAlert(error: $cvm.error)
        .errorAlert(error: $assessmentVM.error)
    }
    
    var filetreeWithPlaceholder: some View {
        VStack {
            if filetreeAsPlaceholder {
                EmptyView()
            } else {
                FiletreeSidebarView(
                    participationID: assessmentVM.submission?.participation?.id,
                    cvm: cvm,
                    loading: assessmentVM.loading,
                    templateParticipationId: (exercise.baseExercise as? ProgrammingExercise)?.templateParticipation?.id
                )
            }
        }
    }
    
    var leftGrip: some View {
        ZStack {
            Color.themisPrimary
                .frame(maxWidth: 7, maxHeight: .infinity)
            
            Rectangle()
                .opacity(0)
                .frame(width: 20, height: 50)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let maxLeftWidth: CGFloat = 0.4 * UIScreen.main.bounds.size.width
                            let delta = gesture.translation.width
                            dragWidthLeft += delta
                            if dragWidthLeft > maxLeftWidth {
                                dragWidthLeft = maxLeftWidth
                            } else if dragWidthLeft < 0 {
                                dragWidthLeft = 0
                            }
                            
                            filetreeAsPlaceholder = dragWidthLeft < minLeftSnapWidth ? true : false
                        }
                        .onEnded {_ in
                            if dragWidthLeft < minLeftSnapWidth {
                                dragWidthLeft = 0.2 * UIScreen.main.bounds.size.width
                                showFileTree = false
                                filetreeAsPlaceholder = false
                            }
                        }
                )
            Image(systemName: "minus")
                .resizable()
                .frame(width: 50, height: 3)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(90))
        }
        .frame(width: 7)
    }
    var rightLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.themisPrimary)
                .frame(width: 70, height: 120)
            VStack {
                Image(systemName: "chevron.up")
                Text("Correction")
                Spacer()
            }
            .foregroundColor(.white)
            .frame(width: 120, height: 70)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            .rotationEffect(.degrees(270))
        }
    }
    var rightGrip: some View {
        ZStack {
            Rectangle()
                .opacity(0)
                .frame(width: dragWidthRight > 0 ? 20 : 70, height: dragWidthRight > 0 ? 50 : 120)
                .contentShape(Rectangle())
                .onTapGesture {
                    if dragWidthRight <= 0 {
                        withAnimation {
                            showCorrectionSidebar = true
                            dragWidthRight = 250
                            correctionAsPlaceholder = false
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let maxRightWidth: CGFloat = 0.4 * UIScreen.main.bounds.size.width
                            let delta = gesture.translation.width
                            dragWidthRight -= delta
                            if dragWidthRight > maxRightWidth {
                                dragWidthRight = maxRightWidth
                            } else if dragWidthRight < 0 {
                                dragWidthRight = 0
                            }
                            
                            correctionAsPlaceholder = dragWidthRight < minRightSnapWidth ? true : false
                        }
                        .onEnded {_ in
                            if dragWidthRight < minRightSnapWidth {
                                showCorrectionSidebar = false
                                dragWidthRight = 0
                            } else {
                                showCorrectionSidebar = true
                            }
                        }
                )
                .zIndex(1)
            
            if dragWidthRight > 0 {
                Color.themisPrimary
                    .frame(maxWidth: 7, maxHeight: .infinity)
                Image(systemName: "minus")
                    .resizable()
                    .frame(width: 50, height: 3)
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(90))
            } else {
                rightLabel
            }
        }
        .frame(width: 7)
    }
    var correctionWithPlaceholder: some View {
        VStack {
            if correctionAsPlaceholder {
                EmptyView()
            } else {
                CorrectionSidebarView( // TODO: Refactor initializer
                    exercise: (assessmentVM.submission?.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise,
                    readOnly: assessmentVM.readOnly,
                    assessmentResult: $assessmentVM.assessmentResult,
                    cvm: cvm,
                    umlVM: umlVM,
                    loading: assessmentVM.loading,
                    problemStatement: (assessmentVM.submission?.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise.problemStatement ?? "",
                    participationId: ((assessmentVM.submission?.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise as? ProgrammingExercise)?.templateParticipation?.id
                )
            }
        }
    }
    
    var pointsDisplay: some View {
        Group {
            if let submission = assessmentVM.submission {
                if (submission as? ProgrammingSubmission)?.buildFailed == true {
                    Text("Build failed")
                        .foregroundColor(.red)
                } else {
                    Text("""
                         \(Double(round(10 * assessmentVM.assessmentResult.points) / 10)
                         .formatted(FloatingPointFormatStyle()))/\
                         \(((submission.participation?.baseParticipation as? ProgrammingExerciseStudentParticipation)?.exercise?.baseExercise.maxPoints ?? 0.0)
                         .formatted(FloatingPointFormatStyle()))
                         """)
                    .foregroundColor(.white)
                }
            }
        }
        .fontWeight(.semibold)
        .background(Color.themisPrimary)
    }
}
