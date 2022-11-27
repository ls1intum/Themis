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

struct FiletreeSidebarView: View {
    @ObservedObject var vm: AssessmentViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.leading, 18)
            if let fileTree = vm.fileTree {
                List {
                    OutlineGroup(fileTree, id: \.path, children: \.children) { tree in
                        Text(tree.name)
                            .tag(tree)
                            .onTapGesture {
                                if tree.type == .file {
                                    withAnimation {
                                        vm.openFile(file: tree)
                                    }
                                }
                            }
                    }.listRowSeparator(.hidden)
                }.listStyle(.inset)
            }
        }
    }
}
