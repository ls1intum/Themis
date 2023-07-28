//
//  RoundedCornerLayoutManager.swift
//  
//
//  Created by Tom Rudnick on 13.12.22.
//

import UIKit

class RoundedCornerLayoutManager: NSLayoutManager {
    
    var showsLineNumbers = true
    var lineNumberFont: UIFont = .systemFont(ofSize: 10)
    var lineNumberTextColor: UIColor = .gray
    var gutterWidth: CGFloat = 0.0
    let paraStyle = NSMutableParagraphStyle()
    var diffLines = [Int]()
    var isNewFile = false
    var feedbackSuggestions = [FeedbackSuggestion]()
    
    override init() {
        super.init()
        self.gutterWidth = numViewWidth()
        self.paraStyle.alignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("This has not been implemented (no body cares anyhow)")
    }

    private var lastParaLocation: Int = 0
    private var lastParaNumber: Int = 0
    
    
    override func drawUnderline(forGlyphRange glyphRange: NSRange,
        underlineType underlineVal: NSUnderlineStyle,
        baselineOffset: CGFloat,
        lineFragmentRect lineRect: CGRect,
        lineFragmentGlyphRange lineGlyphRange: NSRange,
        containerOrigin: CGPoint
    ) {
        let firstPosition = location(forGlyphAt: glyphRange.location).x

        let lastPosition: CGFloat

        if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) {
            lastPosition = location(forGlyphAt: NSMaxRange(glyphRange)).x
        } else {
            lastPosition = lineFragmentUsedRect(
                forGlyphAt: NSMaxRange(glyphRange) - 1,
                effectiveRange: nil).size.width
        }

        var lineRect = lineRect
        let height = lineRect.size.height
        lineRect.origin.x += firstPosition
        lineRect.size.width = lastPosition - firstPosition
        lineRect.size.height = height

        lineRect.origin.x += containerOrigin.x
        lineRect.origin.y += containerOrigin.y

        lineRect = lineRect.integral.insetBy(dx: 0.4, dy: 0.4)
        /// The roundedReect is responsible for the round Corners
        let path = UIBezierPath(roundedRect: lineRect, cornerRadius: height * 0.2)
        path.fill()
    }
    
    private func numViewWidth() -> CGFloat {
        if !showsLineNumbers { return 0.0 }
        let maxNum = 4.0

        let fontAttributes = [NSAttributedString.Key.font: lineNumberFont]
        let width = ("8" as NSString).size(withAttributes: fontAttributes).width
        return maxNum * width + 4.0 * 2
    }
    
    private func getParaNumber(for charRange: NSRange) -> Int {
        if charRange.location == lastParaLocation {
            return lastParaNumber
        } else if charRange.location < lastParaLocation {
            let code = textStorage?.string ?? ""
            let nscode = NSString(string: code)
            var paraNumber = lastParaNumber
            
            nscode.enumerateSubstrings(in: NSRange(location: charRange.location, length: lastParaLocation - charRange.location),
               options: [.byParagraphs, .substringNotRequired, .reverse]) { _, _, enclosingRange, stop in
                if enclosingRange.location <= charRange.location {
                    stop.pointee = true
                }
                paraNumber -= 1
            }
            lastParaLocation = charRange.location
            lastParaNumber = paraNumber
            return paraNumber
        } else {
            let code = textStorage?.string ?? ""
            let ns = NSString(string: code)
            var paraNumber = lastParaNumber
            ns.enumerateSubstrings(in: NSRange(location: lastParaLocation, length: charRange.location - lastParaLocation),
               options: [.byParagraphs, .substringNotRequired]) { _, _, enclosingRange, stop in
                if enclosingRange.location >= charRange.location {
                    stop.pointee = true
                }
                paraNumber += 1
            }
            lastParaLocation = charRange.location
            lastParaNumber = paraNumber
            return paraNumber
        }
    }
    
    override func processEditing(for textStorage: NSTextStorage,
                                 edited editMask: NSTextStorage.EditActions,
                                 range newCharRange: NSRange, changeInLength delta: Int,
                                 invalidatedRange invalidatedCharRange: NSRange) {
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
        if invalidatedCharRange.location < self.lastParaLocation {
            self.lastParaLocation = 0
            self.lastParaNumber = 0
        }
    }
    
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
        let atts: [NSAttributedString.Key: Any] = [.font: lineNumberFont,
                                                   .foregroundColor: lineNumberTextColor,
                                                   .paragraphStyle: paraStyle]
        var gutterRect = CGRect.zero
        var paraNumber = 0
        let ctx = UIGraphicsGetCurrentContext()
        guard let ctx else { return }
        UIGraphicsPushContext(ctx)
        
        enumerateLineFragments(forGlyphRange: glyphsToShow) { rect, _, _, glyphRange, _ in
            
            let charRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let string    = self.textStorage?.string ?? ""
            let paraRange = NSString(string: string).paragraphRange(for: charRange)
            
            if charRange.location == paraRange.location {
                gutterRect = CGRect(x: 0, y: rect.origin.y, width: 40, height: rect.size.height).offsetBy(dx: origin.x, dy: origin.y)
                paraNumber = self.getParaNumber(for: charRange)
                
                if self.showsLineNumbers {
                    self.drawLineNumbers(paraNumber, gutterRect, atts)
                }
            }
            self.drawDiffLines(paraNumber, rect, origin)
            self.drawFeedbackSuggestions(paraNumber, rect, origin)
        }
        UIGraphicsPopContext()

        if NSMaxRange(glyphsToShow) > numberOfGlyphs {
            let ln = String(format: "%ld", paraNumber + 2)
            let size = (ln as NSString).size(withAttributes: atts)
            
            gutterRect = gutterRect.offsetBy(dx: 0, dy: gutterRect.height)
            (ln as NSString).draw(in: CGRect(x: gutterRect.width - 4 - size.width,
                                             y: (gutterRect.height - size.height) / 2.0,
                                             width: size.width,
                                             height: size.height)
                .offsetBy(dx: gutterRect.minX, dy: gutterRect.minY), withAttributes: atts)
        }
    }
    
    private func drawLineNumbers(_ paraNumber: Int, _ gutterRect: CGRect, _ attributes: [NSAttributedString.Key: Any]) {
        let lineNumber = String(format: "%ld", paraNumber + 1) as NSString
        let size = lineNumber.size(withAttributes: attributes)
        lineNumber.draw(in: CGRect(x: 0.0,
                                   y: (gutterRect.height - size.height) / 2.0,
                                   width: self.gutterWidth,
                                   height: size.height)
            .offsetBy(dx: 0.0, dy: gutterRect.minY),
                        withAttributes: attributes)
    }
    
    private func drawDiffLines(_ paraNumber: Int, _ rect: CGRect, _ origin: CGPoint) {
        let ctx = UIGraphicsGetCurrentContext()
        guard let ctx else { return }
        UIGraphicsPushContext(ctx)
        ctx.setFillColor(CGColor(red: 0, green: 0.9, blue: 0.1, alpha: 0.2))
        ctx.setStrokeColor(CGColor(red: 0, green: 0.9, blue: 0.1, alpha: 0.2))
        if self.isNewFile || self.diffLines.contains(where: { paraNumber == $0 }) {
            let path = CGPath(rect: rect.offsetBy(dx: 3, dy: origin.y), transform: nil)
            ctx.addPath(path)
            ctx.drawPath(using: .fillStroke)
        }
        UIGraphicsPopContext()
    }
    
    private func drawFeedbackSuggestions(_ paraNumber: Int, _ rect: CGRect, _ origin: CGPoint) {
        let ctx = UIGraphicsGetCurrentContext()
        guard let ctx else { return }
        UIGraphicsPushContext(ctx)
        ctx.setFillColor(CGColor(red: 0, green: 0.2, blue: 0.8, alpha: 0.8))
        ctx.setStrokeColor(CGColor(red: 0, green: 0.2, blue: 0.8, alpha: 0.8))
        if self.feedbackSuggestions.contains(where: { paraNumber + 1 >= $0.fromLine && paraNumber + 1 <= $0.toLine }) {
            let path = CGPath(
                rect: CGRect(
                    x: rect.origin.x,
                    y: rect.origin.y,
                    width: 5, height: rect.height
                )
                .offsetBy(dx: -2, dy: origin.y),
                transform: nil
            )
            ctx.addPath(path)
            ctx.drawPath(using: .fillStroke)
        }
        UIGraphicsPopContext()
    }
}
