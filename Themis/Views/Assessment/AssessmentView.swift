import SwiftUI

// swiftlint:disable type_body_length
// swiftlint:disable closure_body_length

struct AssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var vm: AssessmentViewModel
    @ObservedObject var cvm: CodeEditorViewModel
    @StateObject var umlVM = UMLViewModel()
    
    @State var showSettings = false
    @State var showFileTree = true
    @State private var dragWidthLeft: CGFloat = UIScreen.main.bounds.size.width * 0.2
    @State private var dragWidthRight: CGFloat = 0
    @State private var correctionAsPlaceholder = true
    @State private var showCancelDialog = false
    @State var showNoSubmissionsAlert = false
    
    private let minRightSnapWidth: CGFloat = 185
    
    let exerciseId: Int
    let exerciseTitle: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            HStack(spacing: 0) {
                if showFileTree {
                    FiletreeSidebarView(
                        participationID: vm.submission?.participation.id,
                        cvm: cvm,
                        loading: vm.loading,
                        templateParticipationId: vm.submission?.participation.exercise.templateParticipation?.id ?? -1
                    )
                    .padding(.top, 35)
                    .frame(width: dragWidthLeft)
                    leftGrip
                        .edgesIgnoringSafeArea(.bottom)
                }
                CodeEditorView(
                    cvm: cvm,
                    showFileTree: $showFileTree
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
            } label: {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 23))
            }
            .padding(.top, 4)
            .padding(.leading, 13)
        }
        .overlay {
            if umlVM.showUMLFullScreen {
                UMLView(umlVM: umlVM)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.primary, for: .navigationBar)
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
                    Text(exerciseTitle)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cvm.lassoMode.toggle()
                    } label: {
                        let iconDrawingColor: Color = cvm.lassoMode ? .yellow : .gray
                        Image(systemName: "pencil.and.outline")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, iconDrawingColor)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
                .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                CustomProgressView(
                    progress: vm.assessmentResult.score,
                    max: vm.submission?.participation.exercise.maxPoints ?? 0
                )
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                scoreDisplay
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
                }
                .buttonStyle(NavigationBarButton())
                .disabled(vm.readOnly || vm.loading)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if let pId = vm.submission?.participation.id {
                            await vm.sendAssessment(participationId: pId, submit: true)
                        }
                    }
                } label: {
                    Text("Submit")
                }
                .buttonStyle(NavigationBarButton())
                .disabled(vm.readOnly || vm.loading)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await vm.initRandomSubmission(exerciseId: exerciseId)
                        if vm.submission == nil {
                            showNoSubmissionsAlert = true
                        }
                    }
                } label: {
                    Text("Next")
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
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                AppearanceSettingsView(
                    fontSize: $cvm.editorFontSize
                )
                .navigationTitle("Appearance settings")
            }
        }
        .sheet(isPresented: $cvm.showAddFeedback) {
            AddFeedbackView(
                assessmentResult: $vm.assessmentResult,
                cvm: cvm,
                type: .inline,
                showSheet: $cvm.showAddFeedback,
                file: cvm.selectedFile
            )
        }
        .sheet(isPresented: $cvm.showEditFeedback) {
            if let feedback = vm.assessmentResult.feedbacks.first(where: { $0.id.uuidString == cvm.feedbackForSelectionId }) {
                EditFeedbackView(assessmentResult: $vm.assessmentResult,
                                 cvm: cvm,
                                 type: .inline,
                                 showSheet: $cvm.showEditFeedback,
                                 idForUpdate: feedback.id)
            }
        }
        .task(priority: .high) {
            if let pId = vm.submission?.participation.id {
                await cvm.initFileTree(participationId: pId)
            }
        }
    }
    var leftGrip: some View {
        ZStack {
            Color.primary
                .frame(maxWidth: 7, maxHeight: .infinity)
            
            Rectangle()
                .opacity(0)
                .frame(width: 20, height: 50)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let screenWidth: CGFloat = UIScreen.main.bounds.size.width
                            let minWidth: CGFloat = screenWidth < 130 ? screenWidth : 130
                            let maxWidth: CGFloat = screenWidth * 0.3 > minWidth ? screenWidth * 0.3 : 1.5 * minWidth
                            let delta = gesture.translation.width
                            dragWidthLeft += delta
                            if dragWidthLeft > maxWidth {
                                dragWidthLeft = maxWidth
                            } else if dragWidthLeft < minWidth {
                                dragWidthLeft = minWidth
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
                .foregroundColor(.primary)
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
                            dragWidthRight = minRightSnapWidth
                            correctionAsPlaceholder = false
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let minWidth: CGFloat = 0
                            let screenWidth: CGFloat = UIScreen.main.bounds.size.width
                            let maxWidth: CGFloat = screenWidth * 0.3 > minRightSnapWidth ? screenWidth * 0.3 : 1.5 * minRightSnapWidth
                            
                            let delta = gesture.translation.width
                            dragWidthRight -= delta
                            if dragWidthRight > maxWidth {
                                dragWidthRight = maxWidth
                            } else if dragWidthRight < minWidth {
                                dragWidthRight = minWidth
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
                Color.primary
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
                    pId: vm.submission?.participation.id,
                    templatePId: vm.submission?.participation.exercise.templateParticipation?.id
                )
            }
        }
    }
    
    var scoreColor: Color {
        guard let max = vm.submission?.participation.exercise.maxPoints else {
            return Color(.systemRed)
        }
        let score = vm.assessmentResult.score
        if score < max / 3 {
            return Color(.systemRed)
        } else if score < max / 3 * 2 {
            return Color(.systemYellow)
        } else {
            return Color(.systemGreen)
        }
    }
    
    var scoreDisplay: some View {
        Group {
            if let submission = vm.submission {
                if submission.buildFailed {
                    Text("Build failed")
                        .foregroundColor(.red)
                } else {
                    Text("""
                         \(Double(round(10 * vm.assessmentResult.score) / 10)
                         .formatted(FloatingPointFormatStyle()))/\
                         \(submission.participation.exercise.maxPoints
                         .formatted(FloatingPointFormatStyle()))
                         """)
                    .foregroundColor(.white)
                }
            }
        }
        .fontWeight(.semibold)
    }
}

extension Color {
    public static var primary: Color {
        Color("primary")
    }
    
    public static var secondary: Color {
        Color("secondary")
    }
}

 struct AssessmentView_Previews: PreviewProvider {
    static let avm = AssessmentViewModel(readOnly: false)
    static let cvm = CodeEditorViewModel()

    static var previews: some View {
        AssessmentView(
            vm: avm,
            cvm: cvm,
            exerciseId: 5284,
            exerciseTitle: "Example Exercise"
        )
            .previewInterfaceOrientation(.landscapeLeft)
    }
 }
