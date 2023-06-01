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
    let readOnly: Bool
    
    var editorItself: some View {
        UXCodeTextViewRepresentable(
            editorBindings: EditorBindings(
                source: $file.code ?? "loading...",
                fontSize: $fontSize,
                language: language,
                themeName: theme,
                flags: editorFlags,
                highlightedRanges: cvm.inlineHighlights[file.path] ?? [],
                dragSelection: $dragSelection,
                showAddFeedback: $cvm.showAddFeedback,
                showEditFeedback: $cvm.showEditFeedback,
                selectedSection: $cvm.selectedSection,
                feedbackForSelectionId: $cvm.feedbackForSelectionId,
                pencilOnly: $cvm.pencilMode,
                scrollUtils: cvm.scrollUtils,
                diffLines: file.diffLines,
                isNewFile: file.isNewFile,
                feedbackSuggestions: readOnly ? [] : cvm.feedbackSuggestions.filter { $0.srcFile == file.path },
                selectedFeedbackSuggestionId: $cvm.selectedFeedbackSuggestionId
            )
        )
        .onChange(of: dragSelection) { newValue in
            if let newValue {
                onOpenFeedback(newValue)
            }
        }
        .onChange(of: cvm.showAddFeedback) { newValue in
            if !newValue {
                dragSelection = nil
            }
        }
    }
    
    
    var body: some View {
        editorItself
    }
    
    var editorFlags: CodeEditor.Flags {
        var flags: CodeEditor.Flags = []
        flags.insert(.selectable)
        if !readOnly { flags.insert(.feedbackMode) }
        return flags
    }
    
    var theme: CodeEditor.ThemeName {
        if colorScheme == .dark {
            return .ocean
        } else {
            return CodeEditor.ThemeName(rawValue: "atelier-seaside-light")
        }
    }
    
    var language: CodeEditor.Language {
        switch file.fileExtension {
        case .java:
            return .java
        case .swift:
            return .swift
        case .other:
            return .basic
        }
    }
}
