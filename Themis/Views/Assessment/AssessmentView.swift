// swiftlint:disable line_length

import SwiftUI

struct AssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var vm: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    @State var showSettings: Bool = false
    @State var showFileTree: Bool = true
    @State private var dragWidthLeft: CGFloat = UIScreen.main.bounds.size.width * 0.2
    @State private var dragWidthRight: CGFloat = 0
    @State private var correctionAsPlaceholder: Bool = true
    @State private var showCancelDialog = false

    let exerciseId: Int

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            HStack(spacing: 0) {
                if showFileTree {
                    FiletreeSidebarView()
                        .padding(.top, 50)
                        .frame(width: dragWidthLeft)
                    leftGrip
                        .edgesIgnoringSafeArea(.bottom)
                }
                CodeEditorView(showFileTree: $showFileTree)
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
            .padding(.top)
            .padding(.leading, 18)
        }
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
                    }
                    .confirmationDialog("Cancel Assessment", isPresented: $showCancelDialog) {
                        Button("Save") {
                            Task {
                                if let pId = vm.submission?.participation.id {
                                    await vm.sendAssessment(participationId: pId, submit: false)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        Button("Discard", role: .destructive) {
                            Task {
                                if let id = vm.submission?.id {
                                    await vm.cancelAssessment(submissionId: id)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    } message: {
                        Text("Either discard the assessment and release the lock (recommended) or keep the lock and save the assessment without submitting it.")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                VStack(alignment: .leading) {
                    Group {
                        Text("Exercise 1")
                            .font(.title)
                            .bold()
                        Text("Correction")
                            .font(.caption)
                            .bold()
                    }
                    .foregroundColor(.white)
                    Spacer(minLength: 20)
                }
            }
            if cvm.currentlySelecting {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        cvm.showAddFeedback.toggle()
                    } label: {
                        Text("Feedback")
                    }
                    .disabled(vm.readOnly)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
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
                .disabled(vm.readOnly)
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
                .disabled(vm.readOnly)
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                AppearanceSettingsView(showSettings: $showSettings)
                    .navigationTitle("Appearance settings")
            }
        }
        .sheet(isPresented: $cvm.showAddFeedback) {
            EditFeedbackView(showEditFeedback: $cvm.showAddFeedback, feedback: nil, edit: false, type: .inline)
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
                            let minWidth: CGFloat = UIScreen.main.bounds.size.width * 0.1
                            let maxWidth: CGFloat = UIScreen.main.bounds.size.width * 0.3
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
                            dragWidthRight = UIScreen.main.bounds.size.width * 0.2
                            correctionAsPlaceholder = false
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let minWidth: CGFloat = 0
                            let maxWidth: CGFloat = UIScreen.main.bounds.size.width * 0.3
                            let delta = gesture.translation.width
                            dragWidthRight -= delta
                            if dragWidthRight > maxWidth {
                                dragWidthRight = maxWidth
                            } else if dragWidthRight < minWidth {
                                dragWidthRight = minWidth
                            }

                            correctionAsPlaceholder = dragWidthRight < UIScreen.main.bounds.size.width * 0.1 ? true : false
                        }
                        .onEnded {_ in
                            if dragWidthRight < UIScreen.main.bounds.size.width * 0.1 {
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
        // TODO: ViewModifier for conditional redacted + remove redacted and remove text when to small as way to laggy
        VStack {
            if correctionAsPlaceholder {
                EmptyView()
            } else {
                CorrectionSidebarView()
            }
        }
    }
}

extension Color {
    public static var primary: Color {
        Color("primary")
    }
}

struct AssessmentView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel(readOnly: false)
    static let codeEditor = CodeEditorViewModel()

    static var previews: some View {
        AssessmentView(exerciseId: 5284)
            .environmentObject(assessment)
            .environmentObject(codeEditor)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
