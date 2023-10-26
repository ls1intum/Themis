//
//  UXCodeTextViewRepresentable.swift
//  CodeEditor
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

import SwiftUI
import UIKit

#if os(macOS)
typealias UXViewRepresentable = NSViewRepresentable
#else
typealias UXViewRepresentable = UIViewRepresentable
#endif

/**
 * Move the gritty details out of the main representable.
 */
public struct UXCodeTextViewRepresentable: UXViewRepresentable {
    
    /**
     * Configures a CodeEditor View with the given parameters.
     *
     * - Parameters:
     *   - source:      A binding to a String that holds the source code to be
     *                  edited (or displayed).
     *   - language:    Optionally set a language (e.g. `.swift`), otherwise
     *                  Highlight.js will attempt to detect the language.
     *   - theme:       The name of the theme to use.
     *   - fontSize:    On macOS this Binding can be used to persist the size of
     *                  the font in use. At runtime this is combined with the
     *                  theme to produce the full font information.
     *   - flags:       Configure whether the text is editable and/or selectable.
     *   - indentStyle: Optionally insert a configurable amount of spaces if the
     *                  user hits "tab".
     *   - inset:       The editor can be inset in the scroll view. Defaults to
     *                  8/8.
     *   - autoPairs:   A mapping of open/close characters, where the close
     *                  characters are automatically injected when the user enters
     *                  the opening character. For example: `[ "<": ">" ]` would
     *                  automatically insert the closing ">" if the user enters
     *                  "<".
     *   - autoscroll:  If enabled, the editor automatically scrolls to the respective
     *                  region when the `selection` is changed programatically.
     */
    
    public init(editorBindings: EditorBindings) {
        self.editorBindings = editorBindings
    }
    
    private var editorBindings: EditorBindings
    
    // The inner `value` is true, exactly when execution is inside
    // the `updateTextView(_:)` method. The `Coordinator` can use this
    // value to guard against update cycles.
    // This needs to be a `State`, as the `UXCodeTextViewRepresentable`
    // might be destructed and recreated in between calls to `makeCoordinator()`
    // and `updateTextView(_:)`.
    @State private var isCurrentlyUpdatingView = ReferenceTypeBool(value: false)
    
    // MARK: - TextView Delegate  Coordinator
    
    public final class Coordinator: NSObject, UXCodeTextViewDelegate {
        
        var parent: UXCodeTextViewRepresentable
        
        var fontSize: CGFloat? {
            get { parent.editorBindings.fontSize?.wrappedValue }
            set { if let value = newValue { parent.editorBindings.fontSize?.wrappedValue = value } }
        }
        
        init(_ parent: UXCodeTextViewRepresentable) {
            self.parent = parent
        }
        
        func setDragSelection(_ dragSelection: Range<Int>?) {
            parent.editorBindings.dragSelection?.wrappedValue = dragSelection
        }
        
        func setSelectedFeedbackSuggestionId(_ id: String) {
            parent.editorBindings.selectedFeedbackSuggestionId.wrappedValue = id
        }
        
        func toggleShowAddFeedback() {
            parent.editorBindings.showAddFeedback.wrappedValue.toggle()
        }
        
#if os(macOS)
        public func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? UXTextView else {
                assertionFailure("unexpected notification object")
                return
            }
            textViewDidChange(textView: textView)
        }
#elseif os(iOS)
        public func textViewDidChange(_ textView: UITextView) {
            textViewDidChange(textView: textView)
        }
#else
#error("Unsupported OS")
#endif
        private func textViewDidChange(textView: UXTextView) {
            // This function may be called as a consequence of updating the text string
            //  in UXCodeTextViewRepresentable/updateTextView(_:)`.
            // Since this function might update the `parent.source` `Binding`, which in
            // turn might update a `State`, this would lead to undefined behavior.
            // (Changing a `State` during a `View` update is not permitted).
            guard !parent.isCurrentlyUpdatingView.value else {
                return
            }
            
            parent.editorBindings.source.wrappedValue = textView.string
        }
        
#if os(macOS)
        public func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? UXTextView else {
                assertionFailure("unexpected notification object")
                return
            }
            
            textViewDidChangeSelection(textView: textView)
        }
#elseif os(iOS)
        public func textViewDidChangeSelection(_ textView: UITextView) {
            guard let textView = textView as? UXCodeTextView else {
                assertionFailure("unexpected textView")
                return
            }
            textViewDidChangeSelection(textView: textView)
        }
#else
#error("Unsupported OS")
#endif
        
        public func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
            var additionalActions: [UIMenuElement] = []
            if range.length > 0 && self.parent.editorBindings.flags.contains(.feedbackMode) {
                let feedbackAction = UIAction(title: "Feedback") { _ in
                    self.parent.editorBindings.showAddFeedback.wrappedValue.toggle()
                }
                additionalActions.append(feedbackAction)
            }
            return UIMenu(children: additionalActions + suggestedActions)
        }
        
        public func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                             in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if interaction == .invokeDefaultAction,
               let feedbackId = UUID(uuidString: URL.absoluteString)
            {
                self.parent.editorBindings.selectedFeedbackForEditingId.wrappedValue = feedbackId
                self.parent.editorBindings.showEditFeedback.wrappedValue = true
            }
            return false
        }
        
        private func textViewDidChangeSelection(textView: UXCodeTextView) {
            // This function may be called as a consequence of updating the selected
            // range in UXCodeTextViewRepresentable/updateTextView(_:)`.
            // Since this function might update the `parent.selection` `Binding`, which in
            // turn might update a `State`, this would lead to undefined behavior.
            // (Changing a `State` during a `View` update is not permitted).
            guard !parent.isCurrentlyUpdatingView.value else {
                return
            }
            // avoid empty references for inline highlights
            if textView.selectedRange.length > 0 {
                parent.editorBindings.selectedSection.wrappedValue = textView.selectedRange
            }
            
            guard let selection = parent.editorBindings.selection else {
                return
            }
            
            let range = textView.swiftSelectedRange
            
            if selection.wrappedValue != range {
                selection.wrappedValue = range
            }
        }
        
        var allowCopy: Bool {
            parent.editorBindings.flags.contains(.selectable)
            || parent.editorBindings.flags.contains(.editable)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func updateTextView(_ textView: UXCodeTextView) {
        isCurrentlyUpdatingView.value = true
        defer {
            isCurrentlyUpdatingView.value = false
        }
        if editorBindings.themeName.rawValue != textView.themeName.rawValue,
           let fontSize = editorBindings.fontSize?.wrappedValue {
            textView.applyNewTheme(editorBindings.themeName, andFontSize: fontSize)
        }
        
        textView.language = editorBindings.language
        textView.indentStyle          = editorBindings.indentStyle
        textView.isSmartIndentEnabled = editorBindings.flags.contains(.smartIndent)
        
        var deletedHighlights = textView.highlightedRanges.filter { !editorBindings.highlightedRanges.contains($0)
        }
        
        if editorBindings.source.wrappedValue != textView.string {
            // reset contentoffset when switching files as it is not stored and content heights of files vary
            deletedHighlights.removeAll()
            textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            if let textStorage = textView.codeTextStorage {
                textStorage.replaceCharacters(
                    in: NSRange(location: 0, length: textStorage.length),
                    with: editorBindings.source.wrappedValue)
            } else {
                assertionFailure("no text storage?")
                textView.string = editorBindings.source.wrappedValue
            }
            if editorBindings.flags.contains(.feedbackMode) {
                textView.feedbackSuggestions = editorBindings.feedbackSuggestions
                textView.updateLightBulbs()
            }
        }
        textView.setNeedsDisplay()
        textView.pencilOnly = editorBindings.pencilOnly.wrappedValue
        textView.dragSelection = self.editorBindings.dragSelection?.wrappedValue
        textView.selectionGranularity = editorBindings.selectionGranularity
        textView.canSelectionIncludeHighlightedRanges = editorBindings.canSelectionIncludeHighlightedRanges
        textView.font = editorBindings.font ?? textView.font
        
        if let binding = editorBindings.fontSize {
            textView.changeFontSize(size: binding.wrappedValue)
        }
       
        if let selection = editorBindings.selection {
            let range = selection.wrappedValue
            
            if range != textView.swiftSelectedRange {
                let nsrange = NSRange(range, in: textView.string)
 #if os(macOS)
                textView.setSelectedRange(nsrange)
 #elseif os(iOS)
                textView.selectedRange = nsrange
 #else
 #error("Unsupported OS")
 #endif
            }
        }
        
        textView.isEditable   = editorBindings.flags.contains(.editable)
        textView.isSelectable = editorBindings.flags.contains(.selectable)
        textView.backgroundColor = UIColor(named: "themisBackground")
        textView.highlightedRanges = editorBindings.highlightedRanges
        textView.customLayoutManager.diffLines = editorBindings.diffLines
        textView.customLayoutManager.isNewFile = editorBindings.isNewFile
        textView.customLayoutManager.showsLineNumbers = editorBindings.showsLineNumbers
        textView.customLayoutManager.feedbackSuggestions = editorBindings.feedbackSuggestions
        
        if editorBindings.language == nil { // plaintext
            textView.textColor = UIColor.label
        }
        
        // check if textView's layout is completed and store offsets of all inline highlights
        if textView.frame.height > 0 {
            editorBindings.highlightedRanges.forEach { range in
                editorBindings.scrollUtils.offsets[range.range] =
                textView.layoutManager.boundingRect(forGlyphRange: range.range, in: textView.textContainer).origin.y
            }
        }
        
        if let range =
            editorBindings.scrollUtils.range {
            DispatchQueue.main.async {
                scrollToRange(textView: textView, range: range)
            }
            self.editorBindings.scrollUtils.range = nil
        }
        textView.updateHighlights(rangesToDelete: deletedHighlights.map({ $0.range }))
    }
    
    private func scrollToRange(textView: UXCodeTextView, range: NSRange) {
        let visibleHeight = textView.visibleSize.height
        let contentHeight = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT))).height
        
        if contentHeight > visibleHeight {
            let rangeOffsetY = editorBindings.scrollUtils.offsets[range] ?? 0.0
            // handle cases where offsetting it to the center is not wanted
            // otherwise the scrollview would jump back on next interaction since min/max scroll range is exceeded
            if rangeOffsetY < (visibleHeight / 2) {
                textView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if (contentHeight - rangeOffsetY) < (visibleHeight / 2) {
                let bottomOffsetY = contentHeight - visibleHeight
                textView.setContentOffset(CGPoint(x: 0, y: bottomOffsetY), animated: true)
            } else {
                textView.setContentOffset(CGPoint(x: 0, y: rangeOffsetY - (visibleHeight / 2)), animated: true)
            }
        }
    }
    
#if os(macOS)
    public func makeNSView(context: Context) -> NSScrollView {
        let textView = UXCodeTextView()
        textView.autoresizingMask   = [ .width, .height ]
        textView.delegate           = context.coordinator
        textView.allowsUndo         = true
        textView.textContainerInset = inset
        
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.documentView = textView
        
        updateTextView(textView)
        return scrollView
    }
    
    public func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? UXCodeTextView else {
            assertionFailure("unexpected text view")
            return
        }
        if textView.delegate !== context.coordinator {
            textView.delegate = context.coordinator
        }
        textView.textContainerInset = inset
        updateTextView(textView)
    }
#else // iOS etc
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UXCodeTextView(showsLineNumbers: editorBindings.showsLineNumbers)
        textView.autoresizingMask   = [ .flexibleWidth, .flexibleHeight ]
        textView.delegate           = context.coordinator
        textView.highlightedRanges = editorBindings.highlightedRanges
        textView.font = editorBindings.font ?? textView.font
#if os(iOS)
        textView.autocapitalizationType = .none
        textView.smartDashesType = .no
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.smartQuotesType = .no
#endif
        updateTextView(textView)
        return textView
    }
    
    
    public func updateUIView(_ textView: UITextView, context: Context) {
        guard let textView = textView as? UXCodeTextView else {
            assertionFailure("unexpected text view")
            return
        }
        if textView.delegate !== context.coordinator {
            textView.delegate = context.coordinator
        }
        updateTextView(textView)
    }
#endif // iOS
}

extension UXCodeTextViewRepresentable {
    // A wrapper around a `Bool` that enables updating
    // the wrapped value during `View` renders.
    private class ReferenceTypeBool {
        var value: Bool
        
        init(value: Bool) {
            self.value = value
        }
    }
}
