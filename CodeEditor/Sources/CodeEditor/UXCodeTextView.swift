//
//  UXCodeTextView.swift
//  CodeEditor
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Highlightr

#if os(macOS)
import AppKit

typealias UXTextView          = NSTextView
typealias UXTextViewDelegate  = NSTextViewDelegate
#else
import UIKit

typealias UXTextView          = UITextView
typealias UXTextViewDelegate  = UITextViewDelegate
#endif

// swiftlint:disable type_body_length
/**
 * Subclass of NSTextView/UITextView which adds some code editing features to
 * the respective Cocoa views.
 *
 * Currently pretty tightly coupled to `CodeEditor`.
 */
final class UXCodeTextView: UXTextView, HighlightDelegate, UIScrollViewDelegate {

    fileprivate let highlightr = Highlightr()

    private var hlTextStorage: CodeAttributedString? {
        textStorage as? CodeAttributedString
    }
    private var customLayoutManager: RoundedCornerLayoutManager!

    /// If the user starts a newline, the editor automagically adds the same
    /// whitespace as on the previous line.
    var isSmartIndentEnabled = true

    var indentStyle          = CodeEditor.IndentStyle.system {
        didSet {
            guard oldValue != indentStyle else { return }
            reindent(oldStyle: oldValue)
        }
    }

    var autoPairCompletion = [ String: String ]()
    var oldWidth: CGFloat = 0.0

    var language: CodeEditor.Language? {
        set {
            guard hlTextStorage?.language != newValue?.rawValue else { return }
            hlTextStorage?.language = newValue?.rawValue
        }
        get { hlTextStorage?.language.flatMap(CodeEditor.Language.init) }
    }
    private(set) var themeName = CodeEditor.ThemeName.default {
        didSet {
            highlightr?.setTheme(to: themeName.rawValue)
            if let font = highlightr?.theme?.codeFont { self.font = font; self.customLayoutManager.lineNumberFont = font }
        }
    }

    var highlightedRanges: [HighlightedRange] = []
    var dragSelection: Range<Int>?
    
    private var firstPoint: CGPoint?
    private var secondPoint: CGPoint?
    
    var pencilOnly: Bool = false {
        didSet {
            if pencilOnly {
                self.panGestureRecognizer.minimumNumberOfTouches = 1
            } else {
                self.panGestureRecognizer.minimumNumberOfTouches = 2
            }
        }
    }
    
    
    init() {
        let textStorage = highlightr.flatMap {
            CodeAttributedString(highlightr: $0)
        }
        ?? NSTextStorage()
        let layoutManager = RoundedCornerLayoutManager()
        customLayoutManager = layoutManager
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer()
        textContainer.widthTracksTextView = true // those are key!
        layoutManager.addTextContainer(textContainer)

        super.init(frame: .zero, textContainer: textContainer)
        if let hlTextStorage {
            hlTextStorage.highlightDelegate = self
        }
        textContainer.exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: 0, width: Int(numViewWidth()) + 10, height: Int(INT_MAX))))
        // self.textContainerInset = UIEdgeInsets(top: 8, left: numViewWidth() + 10, bottom: 8, right: 0)
#if os(macOS)
        isVerticallyResizable = true
        maxSize               = .init(width: 0, height: 1_000_000)

        isRichText                           = false
        allowsImageEditing                   = false
        isGrammarCheckingEnabled             = false
        isContinuousSpellCheckingEnabled     = false
        isAutomaticSpellingCorrectionEnabled = false
        isAutomaticLinkDetectionEnabled      = false
        isAutomaticDashSubstitutionEnabled   = false
        isAutomaticQuoteSubstitutionEnabled  = false
        usesRuler                            = false
#endif
        self.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.panGestureRecognizer.minimumNumberOfTouches = 1
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

#if os(macOS)
    override func changeColor(_ sender: Any?) {
        // https://github.com/ZeeZide/CodeEditor/issues/12
        // Reject user based color changes.
    }

    override func changeFont(_ sender: Any?) {
        let coordinator = delegate as? UXCodeTextViewDelegate

        let old = coordinator?.fontSize
        ?? highlightr?.theme?.codeFont?.pointSize
        ?? NSFont.systemFontSize
        let new: CGFloat

        let fm = NSFontManager.shared
        switch fm.currentFontAction {
        case .sizeUpFontAction: new = old + 1
        case .sizeDownFontAction: new = old - 1

        case .viaPanelFontAction:
            guard let font = fm.selectedFont else {
                return super.changeFont(sender)
            }
            new = font.pointSize

        case .addTraitFontAction, .removeTraitFontAction: // bold/italic
            NSSound.beep()
            return

        default:
            guard let font = fm.selectedFont else {
                return super.changeFont(sender)
            }
            new = font.pointSize
        }

        coordinator?.fontSize = new
        applyNewFontSize(new)
    }
#endif // macOS

    override func copy(_ sender: Any?) {
        guard let coordinator = delegate as? UXCodeTextViewDelegate else {
            assertionFailure("Expected coordinator as delegate")
            return super.copy(sender)
        }
        if coordinator.allowCopy { super.copy(sender) }
    }

    private var isAutoPairEnabled: Bool { !autoPairCompletion.isEmpty }

#if os(iOS)
    override func insertText(_ text: String) {
        super.insertText(text)
        guard isAutoPairEnabled              else { return }
        guard let end = autoPairCompletion[text] else { return }
        let prev = self.selectedRange
        super.insertText(end)
        self.selectedRange = prev
    }
#endif
#if os(macOS)
    // MARK: - Smarts as shown in https://github.com/naoty/NTYSmartTextView

    override func insertNewline(_ sender: Any?) {
        guard isSmartIndentEnabled else { return super.insertNewline(sender) }

        let currentLine = self.currentLine
        let wsPrefix = currentLine.prefix(while: {
            guard let scalar = $0.unicodeScalars.first else { return false }
            return CharacterSet.whitespaces.contains(scalar) // yes, yes
        })

        super.insertNewline(sender)

        if !wsPrefix.isEmpty {
            insertText(String(wsPrefix), replacementRange: selectedRange())
        }
    }

    override func insertTab(_ sender: Any?) {
        guard case .softTab(let width) = indentStyle else {
            return super.insertTab(sender)
        }
        super.insertText(String(repeating: " ", count: width),
                         replacementRange: selectedRange())
    }

    override func insertText(_ string: Any, replacementRange: NSRange) {
        super.insertText(string, replacementRange: replacementRange)
        guard isAutoPairEnabled              else { return }
        guard let string = string as? String else {
            return
        } // TBD: NSAttrString

        guard let end = autoPairCompletion[string] else {
            return
        }
        super.insertText(end, replacementRange: selectedRange())
        super.moveBackward(self)
    }

    override func deleteBackward(_ sender: Any?) {
        guard isAutoPairEnabled, !isStartOrEndOfLine else {
            return super.deleteBackward(sender)
        }

        let s             = self.string
        let selectedRange = swiftSelectedRange
        guard selectedRange.lowerBound > s.startIndex,
              selectedRange.lowerBound < s.endIndex else {
            return super.deleteBackward(sender)
        }

        let startIdx  = s.index(before: selectedRange.lowerBound)
        let startChar = s[startIdx..<selectedRange.lowerBound]
        guard let expectedEndChar = autoPairCompletion[String(startChar)] else {
            return super.deleteBackward(sender)
        }

        let endIdx    = s.index(after: selectedRange.lowerBound)
        let endChar   = s[selectedRange.lowerBound..<endIdx]
        guard expectedEndChar[...] == endChar else {
            return super.deleteBackward(sender)
        }

        super.deleteForward(sender)
        super.deleteBackward(sender)
    }
#endif // macOS

    private func reindent(oldStyle: CodeEditor.IndentStyle) {
        // - walk over the lines, strip and count the whitespaces and do something
        //   clever :-)
    }

    // MARK: - Themes

    @discardableResult
    func applyNewFontSize(_ newSize: CGFloat) -> Bool {
        applyNewTheme(nil, andFontSize: newSize)
    }

    @discardableResult
    func applyNewTheme(_ newTheme: CodeEditor.ThemeName) -> Bool {
        guard themeName != newTheme else { return false }
        guard let highlightr = highlightr,
              highlightr.setTheme(to: newTheme.rawValue),
              let theme      = highlightr.theme else { return false }
        if let font = theme.codeFont, font !== self.font { self.font = font }
        return true
    }

    @discardableResult
    func applyNewTheme(_ newTheme: CodeEditor.ThemeName? = nil,
                       andFontSize newSize: CGFloat) -> Bool {
        // Setting the theme reloads it (i.e. makes a "copy").
        guard let highlightr = highlightr,
              highlightr.setTheme(to: (newTheme ?? themeName).rawValue),
              let theme      = highlightr.theme else { return false }

        if let font = theme.codeFont, font !== self.font { self.font = font }
        guard theme.codeFont?.pointSize != newSize else { return true }

        theme.codeFont       = theme.codeFont?      .withSize(newSize)
        theme.boldCodeFont   = theme.boldCodeFont?  .withSize(newSize)
        theme.italicCodeFont = theme.italicCodeFont?.withSize(newSize)
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bounds.width != oldWidth {
            setNeedsDisplay()
            oldWidth = self.bounds.width
        }
    }

    private func numViewWidth() -> CGFloat {
        let maxNum = 4.0
        if let font {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let width = ("8" as NSString).size(withAttributes: fontAttributes).width
            return maxNum * width + 4.0 * 2
        }
        return 30
    }

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        guard let ctx else { return }
        UIGraphicsPushContext(ctx)
        let numViewW = numViewWidth()
        ctx.setFillColor(CGColor(gray: 0.0, alpha: 0.12))
        let numBgArea = CGRect(x: 0, y: self.contentOffset.y, width: numViewW, height: self.bounds.height)
        ctx.fill(numBgArea)
        
        ctx.setFillColor(CGColor(red: 1.0, green: 0.78, blue: 0.23, alpha: 0.8))
        ctx.setStrokeColor(CGColor(red: 1.0, green: 0.78, blue: 0.23, alpha: 0.8))
        if let dragSelection {
            guard let position1 = self.position(from: self.beginningOfDocument, offset: dragSelection.lowerBound),
                  let position2 = self.position(from: self.beginningOfDocument, offset: dragSelection.endIndex),
                  let range = self.textRange(from: position1, to: position2) else { UIGraphicsPopContext(); return }
            let rects = self.selectionRects(for: range).map(\.rect).filter { $0.width > 0.001 && $0.height > 0.001 }
            for rect in rects {
                let path = CGPath(roundedRect: rect, cornerWidth: 5.0, cornerHeight: 5.0, transform: nil)
                ctx.addPath(path)
                ctx.drawPath(using: .fillStroke)
            }
        }
        UIGraphicsPopContext()
    }
    
    

    func didHighlight(_ range: NSRange, success: Bool) {
        if !text.isEmpty {
            for hRange in highlightedRanges {
                self.textStorage.addAttributes(
                    [
                        .foregroundColor: UIColor.blue,
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: hRange.color,
                        .link: hRange.id // equals feedback id
                    ]
                    , range: hRange.range)
            }
        }
    }
        
    
    private func getGlyphIndex(textView: UXCodeTextView, point: CGPoint) -> Int {
        let point = CGPoint(x: point.x, y: point.y - (self.font?.pointSize ?? 0.0) / 2.0)
        return self.layoutManager.glyphIndex(for: point, in: textView.textContainer)
    }

    private func getSelectionFromLine() -> Range<Int>? {
        guard let firstPoint, let secondPoint else { return nil }
        let firstGlyphIndex = getGlyphIndex(textView: self, point: firstPoint)
        let secondGlyphIndex = getGlyphIndex(textView: self, point: secondPoint)
        if secondGlyphIndex < firstGlyphIndex {
            return secondGlyphIndex..<firstGlyphIndex + 1
        } else {
            return firstGlyphIndex..<secondGlyphIndex + 1
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if pencilOnly && touch.type == .pencil || !pencilOnly {
            self.firstPoint = touch.location(in: self)
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if pencilOnly && touch.type == .pencil || !pencilOnly {
            self.secondPoint = touch.location(in: self)
            self.dragSelection = getSelectionFromLine()
            setNeedsDisplay()
        }
    }
        
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let coordinator = delegate as? UXCodeTextViewDelegate
        coordinator?.setDragSelection(dragSelection)
    }
}

protocol UXCodeTextViewDelegate: UXTextViewDelegate {
    var allowCopy: Bool { get }
    var fontSize: CGFloat? { get set }

    func setDragSelection(_: Range<Int>?)
}

// MARK: - Smarts as shown in https://github.com/naoty/NTYSmartTextView

extension UXTextView {

    var swiftSelectedRange: Range<String.Index> {
        let s = self.string
        guard !s.isEmpty else { return s.startIndex..<s.startIndex }
#if os(macOS)
        guard let selectedRange = Range(self.selectedRange(), in: s) else {
            assertionFailure("Could not convert the selectedRange?")
            return s.startIndex..<s.startIndex
        }
#else
        guard let selectedRange = Range(self.selectedRange, in: s) else {
            assertionFailure("Could not convert the selectedRange?")
            return s.startIndex..<s.startIndex
        }
#endif
        return selectedRange
    }

    fileprivate var currentLine: String {
        let s = self.string
        return String(s[s.lineRange(for: swiftSelectedRange)])
    }

    fileprivate var isEndOfLine: Bool {
        let ( _, isEnd ) = getStartOrEndOfLine()
        return isEnd
    }
    fileprivate var isStartOrEndOfLine: Bool {
        let ( isStart, isEnd ) = getStartOrEndOfLine()
        return isStart || isEnd
    }

    fileprivate func getStartOrEndOfLine() -> ( isStart: Bool, isEnd: Bool ) {
        let s             = self.string
        let selectedRange = self.swiftSelectedRange
        var lineStart = s.startIndex, lineEnd = s.endIndex, contentEnd = s.endIndex
        string.getLineStart(&lineStart, end: &lineEnd, contentsEnd: &contentEnd,
                            for: selectedRange)
        return ( isStart: selectedRange.lowerBound == lineStart,
                 isEnd: selectedRange.lowerBound == lineEnd )
    }
}

// MARK: - UXKit

#if os(macOS)

extension NSTextView {
    var codeTextStorage: NSTextStorage? { textStorage }
}
#else // iOS
extension UITextView {

    var string: String { // NeXTstep was right!
        set { text = newValue}
        get { text }
    }

    var codeTextStorage: NSTextStorage? { textStorage }
}
#endif // iOS
