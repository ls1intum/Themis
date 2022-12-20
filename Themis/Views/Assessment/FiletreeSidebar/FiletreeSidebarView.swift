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
            List {
                OutlineGroup(cvm.fileTree, id: \.path, children: \.children) { tree in
                    if tree.type == .folder {
                        Text(tree.name)
                    } else {
                        Button {
                            withAnimation {
                                guard let pId = assessmentViewModel.submission?.participation.id else {
                                    return
                                }
                                cvm.openFile(
                                    file: tree,
                                    participationId: pId,
                                    templateParticipationId: templateParticipationId
                                )
                            }
                        } label: {
                            Text(tree.name)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .bold(tree === cvm.selectedFile)
                        .background(tree === cvm.selectedFile ? Color(UIColor.systemGray5) : Color(UIColor.systemBackground))
                        .cornerRadius(10)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
        }
    }

}
