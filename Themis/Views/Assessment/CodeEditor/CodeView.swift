import SwiftUI
import CodeEditor

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

struct CodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var dragSelection: Range<Int>?
    var onOpenFeedback: (Range<Int>) -> Void

    var editorItself: some View {
        CodeEditor(source: $file.code ?? "loading...",
                   language: .swift,
                   theme: theme,
                   fontSize: $fontSize,
                   flags: editorFlags,
                   highlightedRanges: cvm.inlineHighlights[file.path] ?? [],
                   dragSelection: $dragSelection,
                   showAddFeedback: $cvm.showAddFeedback,
                   showEditFeedback: $cvm.showEditFeedback,
                   selectedSection: $cvm.selectedSection,
                   feedbackForSelectionId: $cvm.feedbackForSelectionId)
    }
    
    
    var body: some View {
        editorItself
    }

    var editorFlags: CodeEditor.Flags {
        if colorScheme == .dark {
            return [.selectable, .blackBackground]
        } else {
            return .selectable
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
