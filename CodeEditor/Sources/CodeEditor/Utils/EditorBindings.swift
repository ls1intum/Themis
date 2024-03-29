
import Foundation
import SwiftUI

public struct EditorBindings {
    public var source: Binding<String>
    public var selection: Binding<Range<String.Index>>?
    public var font: UIFont?
    public var fontSize: Binding<CGFloat>?
    public let language: CodeEditor.Language?
    public let themeName: CodeEditor.ThemeName
    public let flags: CodeEditor.Flags
    public let indentStyle: CodeEditor.IndentStyle
    public var highlightedRanges: [HighlightedRange]
    public let selectionGranularity: UITextGranularity
    public var dragSelection: Binding<Range<Int>?>?
    public var showAddFeedback: Binding<Bool>
    public var showEditFeedback: Binding<Bool>
    public var selectedSection: Binding<NSRange?>
    public var selectedFeedbackForEditingId: Binding<UUID>
    public var pencilOnly: Binding<Bool>
    public var scrollUtils: ScrollUtils
    public var diffLines: [Int]
    public var isNewFile: Bool
    public var showsLineNumbers: Bool
    public var feedbackSuggestions: [FeedbackSuggestion]
    public var selectedFeedbackSuggestionId: Binding<String>
    
    public init(source: Binding<String>,
                selection: Binding<Range<String.Index>>? = nil,
                font: UIFont? = nil,
                fontSize: Binding<CGFloat>? = nil,
                language: CodeEditor.Language? = nil,
                themeName: CodeEditor.ThemeName = .default,
                flags: CodeEditor.Flags = .defaultEditorFlags,
                indentStyle: CodeEditor.IndentStyle = .system,
                highlightedRanges: [HighlightedRange],
                selectionGranularity: UITextGranularity = .character,
                dragSelection: Binding<Range<Int>?>? = nil,
                showAddFeedback: Binding<Bool>,
                showEditFeedback: Binding<Bool>,
                selectedSection: Binding<NSRange?>,
                selectedFeedbackForEditingId: Binding<UUID>,
                pencilOnly: Binding<Bool>,
                scrollUtils: ScrollUtils,
                diffLines: [Int] = [],
                isNewFile: Bool = false,
                showsLineNumbers: Bool = true,
                feedbackSuggestions: [FeedbackSuggestion],
                selectedFeedbackSuggestionId: Binding<String>
    ) {
        self.source = source
        self.selection = selection
        self.font = font
        self.fontSize = fontSize
        self.language = language
        self.themeName = themeName
        self.flags = flags
        self.indentStyle = indentStyle
        self.highlightedRanges = highlightedRanges
        self.selectionGranularity = selectionGranularity
        self.dragSelection = dragSelection
        self.showAddFeedback = showAddFeedback
        self.showEditFeedback = showEditFeedback
        self.selectedSection = selectedSection
        self.selectedFeedbackForEditingId = selectedFeedbackForEditingId
        self.pencilOnly = pencilOnly
        self.scrollUtils = scrollUtils
        self.diffLines = diffLines
        self.isNewFile = isNewFile
        self.showsLineNumbers = showsLineNumbers
        self.feedbackSuggestions = feedbackSuggestions
        self.selectedFeedbackSuggestionId = selectedFeedbackSuggestionId
    }
}
