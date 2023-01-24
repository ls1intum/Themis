
import Foundation
import SwiftUI

public struct EditorBindings {
    public var source: Binding<String>
    public var selection: Binding<Range<String.Index>>?
    public var fontSize: Binding<CGFloat>?
    public let language: CodeEditor.Language?
    public let themeName: CodeEditor.ThemeName
    public let flags: CodeEditor.Flags
    public let indentStyle: CodeEditor.IndentStyle
    public var highlightedRanges: [HighlightedRange]
    public var dragSelection: Binding<Range<Int>?>?
    public var showAddFeedback: Binding<Bool>
    public var showEditFeedback: Binding<Bool>
    public var selectedSection: Binding<NSRange?>
    public var feedbackForSelectionId: Binding<String>
    public var pencilOnly: Binding<Bool>
    public var scrollUtils: ScrollUtils
    public var diffLines: [Int]
    
    public init(source: Binding<String>,
                selection: Binding<Range<String.Index>>? = nil,
                fontSize: Binding<CGFloat>? = nil,
                language: CodeEditor.Language? = nil,
                themeName: CodeEditor.ThemeName = .default,
                flags: CodeEditor.Flags = .defaultEditorFlags,
                indentStyle: CodeEditor.IndentStyle = .system,
                highlightedRanges: [HighlightedRange],
                dragSelection: Binding<Range<Int>?>? = nil,
                showAddFeedback: Binding<Bool>,
                showEditFeedback: Binding<Bool>,
                selectedSection: Binding<NSRange?>,
                feedbackForSelectionId: Binding<String>,
                pencilOnly: Binding<Bool>,
                scrollUtils: ScrollUtils,
                diffLines: [Int]) {
        self.source = source
        self.selection = selection
        self.fontSize = fontSize
        self.language = language
        self.themeName = themeName
        self.flags = flags
        self.indentStyle = indentStyle
        self.highlightedRanges = highlightedRanges
        self.dragSelection = dragSelection
        self.showAddFeedback = showAddFeedback
        self.showEditFeedback = showEditFeedback
        self.selectedSection = selectedSection
        self.feedbackForSelectionId = feedbackForSelectionId
        self.pencilOnly = pencilOnly
        self.scrollUtils = scrollUtils
        self.diffLines = diffLines
    }
}
