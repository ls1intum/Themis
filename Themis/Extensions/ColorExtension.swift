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
    static let darkRed = Color("themisDarkRed")
    static let neutralFeedbackBackground = Color("neutralFeedbackBackground")
    static let neutralFeedbackPointBackground = Color("neutralFeedbackPointBackground")
    static let neutralFeedbackText = Color("neutralFeedbackText")
    static let positiveFeedbackBackground = Color("positiveFeedbackBackground")
    static let positiveFeedbackPointBackground = Color("positiveFeedbackPointBackground")
    static let positiveFeedbackText = Color("positiveFeedbackText")
    static let negativeFeedbackBackground = Color("negativeFeedbackBackground")
    static let negativeFeedbackPointBackground = Color("negativeFeedbackPointBackground")
    static let negativeFeedbackText = Color("negativeFeedbackText")
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
}
