import SwiftUI

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
                            HStack {
                                Image(systemName: "folder")
                                Text(tree.name)
                            }
                           
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
            iconView(tree: tree)
            Text(tree.name)
        }
    }
    
    @ViewBuilder
    func iconView(tree: Node) -> some View {
        Group {
            if let language = tree.language(), let image = image(for: language, style: .original) {
                image
                    .resizable()
                    .frame(width: 20, height: 20)
            } else {
                Spacer()
                    .frame(width: 30)
            }
        }
    }
    
    func image(for language: Language, style: Style) -> Image? {
        let imageName = "\(language.rawValue)-\(style.rawValue)"
        if let image = UIImage(named: imageName){
            return Image(uiImage: image)
        }
        let alternativeStyle = style == .plain ? Style.original : .plain
        let alternativeImageName = "\(language.rawValue)-\(alternativeStyle.rawValue)"
        if let image = UIImage(named: alternativeImageName) {
            return Image(uiImage: image)
        }
        return nil
    }

}
