import SwiftUI

// swiftlint:disable type_body_length
// swiftlint:disable closure_body_length

struct AssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var vm: AssessmentViewModel
    @StateObject var cvm = CodeEditorViewModel()
    @ObservedObject var ar: AssessmentResult
    @StateObject var umlVM = UMLViewModel()
    
    @State var showFileTree = true
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
                        .padding(.top, 35)
                        .frame(width: dragWidthLeft)
                    leftGrip
                        .edgesIgnoringSafeArea(.bottom)
                }
                CodeEditorView(
                    cvm: cvm,
                    showFileTree: $showFileTree,
                    readOnly: vm.readOnly
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                rightGrip
                    .edgesIgnoringSafeArea(.bottom)
                correctionWithPlaceholder
                    .frame(width: dragWidthRight)
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
            ar.maxPoints = exercise.maxPoints ?? 100
        }
        .onDisappear {
            vm.assessmentResult.undoManager.removeAllActions()
        }
        .overlay {
            if umlVM.showUMLFullScreen {
                UMLView(umlVM: umlVM)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color("customPrimary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if vm.readOnly {
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
                                if let pId = vm.submission?.participation.id {
                                    await vm.sendAssessment(participationId: pId, submit: false)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        Button("Discard", role: .destructive) {
                            Task {
                                if let id = vm.submission?.id {
                                    await vm.cancelAssessment(submissionId: id)
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
                    Text(exercise.title ?? "")
                        .bold()
                        .font(.title)
                    Image(systemName: vm.readOnly ? "eyeglasses" : "pencil.and.outline")
                        .font(.title3)
                }
                .foregroundColor(.white)
            }

            if vm.loading {
                ToolbarItem(placement: .navigationBarLeading) {
                    ProgressView()
                        .frame(width: 20)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                }
            }

            if !vm.readOnly {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut) {
                            vm.assessmentResult.undo()
                        }
                    } label: {
                        let undoIconColor: Color = !vm.assessmentResult.canUndo() ? .gray : .white
                        Image(systemName: "arrow.uturn.backward")
                            .foregroundStyle(undoIconColor)
                    }
                    .disabled(!vm.assessmentResult.canUndo())
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut) {
                            vm.assessmentResult.redo()
                        }
                    } label: {
                        let redoIconColor: Color = !vm.assessmentResult.canRedo() ? .gray : .white
                        Image(systemName: "arrow.uturn.forward")
                            .foregroundStyle(redoIconColor)
                    }
                    .disabled(!vm.assessmentResult.canRedo())
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
                    progress: vm.assessmentResult.score,
                    max: vm.submission?.participation.exercise.maxPoints ?? 0
                )
                pointsDisplay
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if let pId = vm.submission?.participation.id {
                            await vm.sendAssessment(participationId: pId, submit: false)
                        }
                    }
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                }
                .buttonStyle(NavigationBarButton())
                .disabled(vm.readOnly || vm.loading)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSubmitConfirmation.toggle()
                } label: {
                    Text("Submit")
                        .foregroundColor(.white)
                }
                .buttonStyle(NavigationBarButton())
                .disabled(vm.readOnly || vm.loading)
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
                    if let pId = vm.submission?.participation.id {
                        await vm.sendAssessment(participationId: pId, submit: true)
                        await vm.notifyThemisML(participationId: pId, exerciseId: exercise.id)
                    }
                    showNavigationOptions.toggle()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("What do you want to do next?", isPresented: $showNavigationOptions) {
            Button("Next Submission") {
                Task {
                    await vm.initRandomSubmission(exerciseId: exercise.id)
                    if vm.submission == nil {
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
                assessmentResult: vm.assessmentResult,
                cvm: cvm,
                type: .inline,
                showSheet: $cvm.showAddFeedback,
                file: cvm.selectedFile,
                gradingCriteria: vm.submission?.participation.exercise.gradingCriteria ?? [],
                feedbackSuggestion: cvm.feedbackSuggestions.first { $0.id.uuidString == cvm.selectedFeedbackSuggestionId }
            )
        })
        .sheet(isPresented: $cvm.showEditFeedback) {
            if let feedback = vm.assessmentResult.feedbacks.first(where: { $0.id.uuidString == cvm.feedbackForSelectionId }) {
                EditFeedbackView(
                    assessmentResult: vm.assessmentResult,
                    cvm: cvm,
                    type: .inline,
                    showSheet: $cvm.showEditFeedback,
                    idForUpdate: feedback.id,
                    gradingCriteria: vm.submission?.participation.exercise.gradingCriteria ?? []
                )
            }
        }
        .task(priority: .high) {
            if let submissionId, vm.submission == nil {
                await vm.getSubmission(id: submissionId)
            }
            if let pId = vm.submission?.participation.id {
                await cvm.initFileTree(participationId: pId)
                await cvm.loadInlineHighlight(assessmentResult: vm.assessmentResult, participationId: pId)
                await cvm.getFeedbackSuggestions(participationId: pId, exerciseId: exercise.id)
            }
        }
        .onRotate { newOrientation in
            if newOrientation == UIDeviceOrientation.portrait || newOrientation == UIDeviceOrientation.portraitUpsideDown {
                if dragWidthLeft > 
            }
        }
    }
    
    var filetreeWithPlaceholder: some View {
        VStack {
            if filetreeAsPlaceholder {
                EmptyView()
            } else {
                FiletreeSidebarView(
                    participationID: vm.submission?.participation.id,
                    cvm: cvm,
                    loading: vm.loading,
                    templateParticipationId: exercise.templateParticipation?.id
                )
            }
        }
    }
    
    var leftGrip: some View {
        ZStack {
            Color("customPrimary")
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
                .foregroundColor(Color("customPrimary"))
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
                            dragWidthRight = 0.2 * UIScreen.main.bounds.size.width
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
                                dragWidthRight = 0
                            }
                        }
                )
                .zIndex(1)
            
            if dragWidthRight > 0 {
                Color("customPrimary")
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
                CorrectionSidebarView(
                    problemStatement: Binding(
                        get: { vm.submission?.participation.exercise.problemStatement ?? "" },
                        set: { vm.submission?.participation.exercise.problemStatement = $0 }
                    ),
                    exercise: vm.submission?.participation.exercise,
                    readOnly: vm.readOnly,
                    assessmentResult: $vm.assessmentResult,
                    cvm: cvm,
                    umlVM: umlVM,
                    loading: vm.loading,
                    participationId: vm.submission?.participation.id,
                    templateParticipationId: vm.submission?.participation.exercise.templateParticipation?.id
                )
            }
        }
    }
    
    var pointsDisplay: some View {
        Group {
            if let submission = vm.submission {
                if submission.buildFailed {
                    Text("Build failed")
                        .foregroundColor(.red)
                } else {
                    Text("""
                         \(Double(round(10 * vm.assessmentResult.points) / 10)
                         .formatted(FloatingPointFormatStyle()))/\
                         \(submission.participation.exercise.maxPoints
                         .formatted(FloatingPointFormatStyle()))
                         """)
                    .foregroundColor(.white)
                }
            }
        }
        .fontWeight(.semibold)
        .background(Color("customPrimary"))
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

 struct AssessmentView_Previews: PreviewProvider {
    static let avm = AssessmentViewModel(readOnly: false)

    static var previews: some View {
        AssessmentView(
            vm: avm,
            ar: avm.assessmentResult,
            exercise: Exercise()
        )
            .previewInterfaceOrientation(.landscapeLeft)
    }
 }
