//
//  RoundedCornerLayoutManager.swift
//  
//
//  Created by Tom Rudnick on 13.12.22.
//

import UIKit

class RoundedCornerLayoutManager: NSLayoutManager {
    override func drawUnderline(forGlyphRange glyphRange: NSRange,
        underlineType underlineVal: NSUnderlineStyle,
        baselineOffset: CGFloat,
        lineFragmentRect lineRect: CGRect,
        lineFragmentGlyphRange lineGlyphRange: NSRange,
        containerOrigin: CGPoint
    ) {
        let firstPosition  = location(forGlyphAt: glyphRange.location).x

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
}
