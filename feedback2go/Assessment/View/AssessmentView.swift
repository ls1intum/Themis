import SwiftUI

struct FileCellView: View {
    var file: CodeFile

    var body: some View {
        HStack {
            Image(systemName: "insert_drive_file")
            Text(file.title)
        }
    }
}

struct AssessmentView: View {
    @StateObject var model = AssessmentViewModel.mock
    @State var showSettings: Bool = false
    @State var showFileTree: Bool = true
    @State private var dragWidthLeft: CGFloat = UIScreen.main.bounds.size.width * 0.2
    @State private var dragWidthRight: CGFloat = 0

    let artemisColor = Color(#colorLiteral(red: 0.20944947, green: 0.2372354269, blue: 0.2806544006, alpha: 1))

    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                HStack(spacing: 0) {
                    if showFileTree {
                        sidebar
                            .padding(.top, 50)
                            .frame(width: dragWidthLeft)
                        leftGrip
                            .edgesIgnoringSafeArea(.bottom)
                    }
                    code
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    rightGrip
                        .edgesIgnoringSafeArea(.bottom)
                    correction
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
                                .font(.caption2)
                                .bold()
                        }
                        .foregroundColor(.white)
                        Spacer(minLength: 20)
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
                    } label: {
                        Text("Submit")
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                AppearanceSettingsView(model: model, showSettings: $showSettings)
                    .navigationTitle("Appearance settings")
            }
        }
    }
    var sidebar: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.leading, 18)
            if let fileTree = model.fileTree {
                List {
                    OutlineGroup(fileTree, id: \.path, children: \.children) { tree in
                        Text(tree.name)
                            .tag(tree)
                            .onTapGesture {
                                if tree.type == .file {
                                    withAnimation {
                                        model.openFile(file: tree)
                                    }
                                }
                            }
                    }.listRowSeparator(.hidden)
                }.listStyle(.inset)
            }
        }
    }
    var leftGrip: some View {
        ZStack {
            artemisColor
                .frame(maxWidth: 7, maxHeight: .infinity)
            Image(systemName: "minus")
                .resizable()
                .frame(width: 50, height: 3)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(90))
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
        }
        .frame(width: 7)
    }
    var code: some View {
        VStack {
            if model.selectedFile != nil {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView(model: model)
                    }
                    CodeView(model: model)
                }
            } else {
                Text("Select a file")
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
    var rightLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(artemisColor)
                .frame(width: 120, height: 70)
            VStack {
                Image(systemName: "chevron.up")
                Text("Correction")
                Spacer()
            }
            .foregroundColor(.white)
            .frame(width: 120, height: 70)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            .onTapGesture {
                withAnimation {
                    dragWidthRight = UIScreen.main.bounds.size.width * 0.2
                }
            }
        }
        .frame(width: 0, height: 120)
        .rotationEffect(.degrees(270))
    }
    var rightGrip: some View {
        ZStack {
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
                }
                .onEnded {_ in
                    if dragWidthRight < UIScreen.main.bounds.size.width * 0.1 {
                        dragWidthRight = 0
                    }
                }
        )
    }
    var correction: some View {
        Text("CorrectionSidebar")
    }
}

struct AssessmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
