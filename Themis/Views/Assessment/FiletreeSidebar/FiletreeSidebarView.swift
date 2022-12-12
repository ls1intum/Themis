import SwiftUI

struct FiletreeSidebarView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    let templateParticipationId: Int

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
                            .bold(tree == cvm.selectedFile)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .background(tree === cvm.selectedFile ? Color(UIColor.systemGray5) : Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .tag(tree)
                            .onTapGesture {
                                if tree.type == .file {
                                    withAnimation {
                                        guard let pId = assessmentViewModel.submission?.participation.id else { return }
                                        cvm.openFile(file: tree, participationId: pId, templateParticipationId: templateParticipationId)
                                    }
                                }
                            }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.inset)
            }
        }
    }
}
