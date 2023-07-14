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
    
    private var hideSuggestions: Bool {
        readOnly || !cvm.allowsInlineFeedbackOperations
    }
    
    private var highlightedRanges: [HighlightedRange] {
        guard cvm.allowsInlineFeedbackOperations,
              let highlights = cvm.inlineHighlights[file.path] else {
            return []
        }
        return highlights
    }
    
    var editorItself: some View {
        UXCodeTextViewRepresentable(
            editorBindings: EditorBindings(
                source: $file.code ?? "loading...",
                fontSize: $fontSize,
                language: language,
                themeName: theme,
                flags: editorFlags,
                highlightedRanges: highlightedRanges,
                dragSelection: $dragSelection,
                showAddFeedback: $cvm.showAddFeedback,
                showEditFeedback: $cvm.showEditFeedback,
                selectedSection: $cvm.selectedSection,
                feedbackForSelectionId: $cvm.feedbackForSelectionId,
                pencilOnly: $cvm.pencilModeDisabled,
                scrollUtils: cvm.scrollUtils,
                diffLines: file.diffLines,
                isNewFile: file.isNewFile,
                feedbackSuggestions: hideSuggestions ? [] : cvm.feedbackSuggestions.filter { $0.srcFile == file.path },
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
        if colorScheme == .dark { flags.insert(.blackBackground) }
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
