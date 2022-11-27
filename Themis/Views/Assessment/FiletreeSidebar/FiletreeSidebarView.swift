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
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel

    @ObservedObject var vm: CodeEditorViewModel

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
                                        guard let pId = assessmentViewModel.submission?.participation.id else { return }
                                        vm.openFile(file: tree, participationId: pId)
                                    }
                                }
                            }
                    }.listRowSeparator(.hidden)
                }.listStyle(.inset)
            }
        }
    }
}
