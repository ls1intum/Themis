import SwiftUI

struct CodeEditorView: View {
    @ObservedObject var cvm: CodeEditorViewModel

    @Binding var showFileTree: Bool

    var body: some View {
        VStack {
            if let file = cvm.selectedFile {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView(cvm: cvm)
                    }
                    CodeView(cvm: cvm, file: file)
                }
            } else {
                Text("Select a file")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}
