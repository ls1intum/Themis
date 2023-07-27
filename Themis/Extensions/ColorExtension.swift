//
//  ColorExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.04.23.
//

import SwiftUI

extension Color {
    static let themisPrimary = Color("themisPrimary")
    static let themisSecondary = Color("themisSecondary")
    static let themisGreen = Color("themisGreen")
    static let themisDarkRed = Color("themisDarkRed")
    static let themisRed = Color("themisRed")
    static let themisBackground = Color("themisBackground")
    
    // Neutral Feedback
    static let neutralFeedbackBackground = Color("neutralFeedbackBackground")
    static let neutralFeedbackPointBackground = Color("neutralFeedbackPointBackground")
    static let neutralFeedbackText = Color("neutralFeedbackText")
    static let neutralTextHighlight = UIColor(.init(netHex: 0xFFCC00), darkModeColor: .init(netHex: 0xC59D00)).suColor

    // Positive Feedback
    static let positiveFeedbackBackground = Color("positiveFeedbackBackground")
    static let positiveFeedbackPointBackground = Color("positiveFeedbackPointBackground")
    static let positiveFeedbackText = Color("positiveFeedbackText")
    static let positiveTextHighlight = UIColor(.init(netHex: 0xB0FFB4), darkModeColor: .init(netHex: 0x48A34B)).suColor

    // Negative Feedback
    static let negativeFeedbackBackground = Color("negativeFeedbackBackground")
    static let negativeFeedbackPointBackground = Color("negativeFeedbackPointBackground")
    static let negativeFeedbackText = Color("negativeFeedbackText")
    static let negativeTextHighlight = UIColor(.init(netHex: 0xFF6F6F), darkModeColor: .init(netHex: 0xF14F4F)).suColor
    
    // Modeling Assessment
    static let selectedUMLItemColor = themisSecondary.opacity(0.5)
}

extension Color {
    static func getBackgroundColor(forCredits credits: Double) -> Self {
        if credits < 0.0 {
            return .negativeFeedbackBackground
        } else if credits > 0.0 {
            return .positiveFeedbackBackground
        } else {
            return .neutralFeedbackBackground
        }
    }
    
    static func getTextColor(forCredits credits: Double) -> Self {
        if credits < 0.0 {
            return .negativeFeedbackText
        } else if credits > 0.0 {
            return .positiveFeedbackText
        } else {
            return .neutralFeedbackText
        }
    }
    
    static func getPointsBackgroundColor(forCredits credits: Double) -> Self {
        if credits < 0.0 {
            return .negativeFeedbackPointBackground
        } else if credits > 0.0 {
            return .positiveFeedbackPointBackground
        } else {
            return .neutralFeedbackPointBackground
        }
    }
    
    static func getHighlightColor(forCredits credits: Double) -> Self {
        if credits < 0.0 {
            return .negativeTextHighlight
        } else if credits > 0.0 {
            return .positiveTextHighlight
        } else {
            return .neutralTextHighlight
        }
    }
}
