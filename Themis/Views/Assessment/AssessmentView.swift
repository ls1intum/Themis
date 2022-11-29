import SwiftUI

struct AssessmentView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var vm: AssessmentViewModel

    @StateObject var codeEditorViewModel = CodeEditorViewModel()
    @StateObject var feedbackViewModel = FeedbackViewModel()

    @State var showAddFeedback: Bool = false
    @State var showSettings: Bool = false
    @State var showFileTree: Bool = true
    @State private var dragWidthLeft: CGFloat = UIScreen.main.bounds.size.width * 0.2
    @State private var dragWidthRight: CGFloat = 0
    @State private var correctionAsPlaceholder: Bool = true

    private let exerciseId: Int

    init(exerciseId: Int) {
        self.exerciseId = exerciseId
    }

    let artemisColor = Color(#colorLiteral(red: 0.20944947, green: 0.2372354269, blue: 0.2806544006, alpha: 1))

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            HStack(spacing: 0) {
                if showFileTree {
                    FiletreeSidebarView(vm: codeEditorViewModel)
                        .padding(.top, 50)
                        .frame(width: dragWidthLeft)
                    leftGrip
                        .edgesIgnoringSafeArea(.bottom)
                }
                CodeEditorView(vm: codeEditorViewModel, fvm: feedbackViewModel, showFileTree: $showFileTree)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                rightGrip
                    .edgesIgnoringSafeArea(.bottom)
                correctionWithPlaceholder
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
        .toolbarBackground(artemisColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                } label: {
                    Text("Back")
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
            if codeEditorViewModel.currentlySelecting {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddFeedback.toggle()
                    } label: {
                        Text("Feedback")
                    }
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
                    showFileTree.toggle()
                } label: {
                    Text("Submit")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                AppearanceSettingsView(vm: codeEditorViewModel, showSettings: $showSettings)
                    .navigationTitle("Appearance settings")
            }
        }
        .sheet(isPresented: $showAddFeedback) {
            AddFeedbackView(feedbackModel: feedbackViewModel,
                            showAddFeedback: $showAddFeedback,
                            type: .inline,
                            lineReference: codeEditorViewModel.selectedLineNumber,
                            file: codeEditorViewModel.selectedFile)
        }
        .task(priority: .high) {
            if let pId = vm.submission?.participation.id {
                await codeEditorViewModel.initFileTree(participationId: pId)
            }
        }
    }
    var leftGrip: some View {
        ZStack {
            artemisColor
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
                .foregroundColor(artemisColor)
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
                artemisColor
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
                CorrectionSidebarView(feedbackViewModel: feedbackViewModel)
                    .frame(width: dragWidthRight)
                    .redacted(reason: .placeholder)
            } else {
                CorrectionSidebarView(feedbackViewModel: feedbackViewModel)
                    .frame(width: dragWidthRight)
            }
        }
    }
}

struct AssessmentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            AssessmentView(exerciseId: 5284)
                .environmentObject(AssessmentViewModel())
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
