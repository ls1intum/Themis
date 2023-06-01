import SwiftUI
import CodeEditor

struct CodeEditorView: View {
    @ObservedObject var cvm: CodeEditorViewModel

    @Binding var showFileTree: Bool
    let readOnly: Bool

    private func openFeedbackSheet(forRange dragRange: Range<Int>) {
        cvm.selectedSection = dragRange.toNSRange()
        cvm.showAddFeedback = true
    }

    var body: some View {
        VStack {
            if let file = cvm.selectedFile {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 55)
                        TabsView(cvm: cvm)
                    }
                    CodeView(
                        cvm: cvm,
                        file: file,
                        fontSize: $cvm.editorFontSize,
                        onOpenFeedback: openFeedbackSheet,
                        readOnly: readOnly
                    )
                }
            } else {
                Text("Select a file")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.themisBackground)
    }
}
