//
//  RoundedCornerLayoutManager.swift
//  
//
//  Created by Tom Rudnick on 13.12.22.
//

import UIKit

class RoundedCornerLayoutManager: NSLayoutManager {
    
    var lineNumberFont: UIFont = .systemFont(ofSize: 10)
    var lineNumberTextColor: UIColor = .gray
    var gutterWidth: CGFloat = 0.0
    let paraStyle = NSMutableParagraphStyle()
    
    
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
        let path = UIBezierPath(roundedRect: lineRect, cornerRadius: 5)
        path.fill()
    }
    
    private func numViewWidth() -> CGFloat {
        let maxNum = 4.0

        let fontAttributes = [NSAttributedString.Key.font: lineNumberFont]
        let width = ("8" as NSString).size(withAttributes: fontAttributes).width
        return maxNum * width + 4.0 * 2
    }
    
    private func getParaNumber(for charRange: NSRange) -> Int {
        if charRange.location == lastParaLocation {
            return lastParaNumber
        } else if charRange.location < lastParaLocation {
            let s = textStorage?.string ?? ""
            let ns = NSString(string: s)
            var paraNumber = lastParaNumber
            
            ns.enumerateSubstrings(in: NSMakeRange(charRange.location, lastParaLocation - charRange.location), options: [.byParagraphs, .substringNotRequired, .reverse]) { (substring, substringRange, enclosingRange, stop) in
                if enclosingRange.location <= charRange.location {
                    stop.pointee = true
                }
                paraNumber -= 1
            }
            lastParaLocation = charRange.location
            lastParaNumber = paraNumber
            return paraNumber
        } else {
            let s = textStorage?.string ?? ""
            let ns = NSString(string: s)
            var paraNumber = lastParaNumber
            ns.enumerateSubstrings(in: NSMakeRange(lastParaLocation, charRange.location - lastParaLocation), options: [.byParagraphs, .substringNotRequired]) { (substring, substringRange, enclosingRange, stop) in
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
    
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorage.EditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
        if (invalidatedCharRange.location < self.lastParaLocation) {
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

        enumerateLineFragments(forGlyphRange: glyphsToShow) { (rect, usedRect, textContainer, glyphRange, stop) in
            
            let charRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let string    = self.textStorage?.string ?? ""
            let paraRange = NSString(string: string).paragraphRange(for: charRange)
            
            if charRange.location == paraRange.location {
                gutterRect = CGRect(x: 0, y: rect.origin.y, width: 40, height: rect.size.height).offsetBy(dx: origin.x, dy: origin.y)
                paraNumber = self.getParaNumber(for: charRange)
                let ln = String(format: "%ld", paraNumber + 1) as NSString
                let size = ln.size(withAttributes: atts)
                
                ln.draw(in: CGRect(x: 0.0,
                                   y: (gutterRect.height - size.height) / 2.0,
                                   width: self.gutterWidth,
                                   height: size.height)
                    .offsetBy(dx: 0.0, dy: gutterRect.minY),
                        withAttributes: atts)
            }
        }

        if NSMaxRange(glyphsToShow) > numberOfGlyphs {
            let ln = String(format: "%ld", paraNumber + 2)
            let size = (ln as NSString).size(withAttributes: atts)
            
            gutterRect = gutterRect.offsetBy(dx: 0, dy: gutterRect.height)
            (ln as NSString).draw(in: CGRect(x: gutterRect.width - 4 - size.width, y: (gutterRect.height - size.height) / 2.0, width: size.width, height: size.height).offsetBy(dx: gutterRect.minX, dy: gutterRect.minY), withAttributes: atts)
        }
    }
}
