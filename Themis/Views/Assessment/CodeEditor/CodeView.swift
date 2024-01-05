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
    
    private var suggestions: [ProgrammingFeedbackSuggestion] {
        cvm.feedbackSuggestions.filter { $0.filePath?.appendingLeadingSlashIfMissing() == file.path }
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
                language: file.fileExtension.codeEditorLang,
                themeName: theme,
                flags: editorFlags,
                highlightedRanges: highlightedRanges,
                dragSelection: $dragSelection,
                showAddFeedback: $cvm.showAddFeedback,
                showEditFeedback: $cvm.showEditFeedback,
                selectedSection: $cvm.selectedSection,
                selectedFeedbackForEditingId: $cvm.selectedFeedbackForEditingId,
                pencilOnly: $cvm.pencilModeDisabled,
                scrollUtils: cvm.scrollUtils,
                diffLines: file.diffLines,
                isNewFile: file.isNewFile,
                feedbackSuggestions: hideSuggestions ? [] : suggestions,
                selectedFeedbackSuggestionId: $cvm.selectedFeedbackSuggestionId
            )
        )
        .onChange(of: dragSelection) { _, newValue in
            if let newValue {
                onOpenFeedback(newValue)
            }
        }
        .onChange(of: cvm.showAddFeedback) { _, newValue in
            if !newValue {
                dragSelection = nil
            }
        }
    }
    
    
    var body: some View {
        editorItself
    }
    
    var editorFlags: CodeEditor.Flags { CodeEditor.Flags.selectable }
    
    var theme: CodeEditor.ThemeName {
        if colorScheme == .dark {
            return .ocean
        } else {
            return CodeEditor.ThemeName(rawValue: "atelier-seaside-light")
        }
    }
}
