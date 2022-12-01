import SwiftUI

struct FiletreeSidebarView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.leading, 18)
            if let fileTree = cvm.fileTree {
                List {
                    OutlineGroup(fileTree, id: \.path, children: \.children) { tree in
                        Text(tree.name)
                            .tag(tree)
                            .onTapGesture {
                                if tree.type == .file {
                                    withAnimation {
                                        guard let pId = assessmentViewModel.submission?.participation.id else { return }
                                        cvm.openFile(file: tree, participationId: pId)
                                    }
                                }
                            }
                    }.listRowSeparator(.hidden)
                }.listStyle(.inset)
            }
        }
    }
}
