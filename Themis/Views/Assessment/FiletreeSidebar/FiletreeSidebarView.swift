import SwiftUI
import DeviconWrapper

struct FiletreeSidebarView: View {
    let participationID: Int?
    @ObservedObject var cvm: CodeEditorViewModel
    let loading: Bool

    let templateParticipationId: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.leading, 18)
            if !loading {
                List {
                    OutlineGroup(cvm.fileTree, id: \.path, children: \.children) { tree in
                        if tree.type == .folder {
                            Text(tree.name)
                        } else {
                            Button {
                                withAnimation {
                                    guard let participationID else { return }
                                    cvm.openFile(file: tree,
                                             participationId: participationID,
                                             templateParticipationId: templateParticipationId
                                    )
                                }
                            } label: {
                                fileView(tree: tree)
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
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder
    func fileView(tree: Node) -> some View {
        HStack {
            iconView(fileExtension: tree.fileExtensionString)
            Text(tree.name)
        }
    }
    
    @ViewBuilder
    func iconView(fileExtension: String) -> some View {
        let iconFinder = IconFinder()
        Group {
            if let image = iconFinder.icon(for: fileExtension, style: .original) {
                image
            } else {
                EmptyView()
            }
        }.frame(width: 20, height: 20)
    }
}
