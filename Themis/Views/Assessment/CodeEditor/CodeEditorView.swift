import SwiftUI
import CodeEditor

struct CodeEditorView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    @Binding var showFileTree: Bool

    var body: some View {
        VStack {
            if let file = cvm.selectedFile {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView()
                    }
                    CodeViewNew(file: file, fontSize: $cvm.editorFontSize)
                }
            } else {
                Text("Select a file")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

struct CodeViewNew: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    
    var body: some View {
        CodeEditor(source: file.code ?? "loading...", language: .swift, theme: theme, fontSize: $fontSize, flags: editorFlags)
    }
    
    var editorFlags: CodeEditor.Flags {
        if colorScheme == .dark {
            return .blackBackground
        } else {
            return CodeEditor.Flags()
        }
    }
    
    var theme: CodeEditor.ThemeName {
        if colorScheme == .dark {
            return .ocean
        } else {
            return .xcode
        }
    }
}
