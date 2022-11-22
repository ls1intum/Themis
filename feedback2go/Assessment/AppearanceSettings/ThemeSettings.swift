import Runestone
import Foundation
import UIKit
import SwiftUI

// class used to adjust various editor theme properties
class ThemeSettings: Theme {
    // font size could only be adjusted in this view as there are no setters in Runestone for the editor font size
    // currently using the "defaultTheme" theme
    init(font: UIFont) {
        self.font = font
    }
    let font: UIFont
    let textColor: UIColor = .defaultTheme.foreground
    let gutterBackgroundColor: UIColor = .defaultTheme.background
    let gutterHairlineColor: UIColor = .defaultTheme.background
    let lineNumberColor: UIColor = .defaultTheme.comment
    // TBD: should line number font size be the same as the editor font size?
    let lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 14, weight: .regular)
    let selectedLineBackgroundColor: UIColor = .defaultTheme.currentLine
    let selectedLinesLineNumberColor: UIColor = .defaultTheme.foreground
    let selectedLinesGutterBackgroundColor: UIColor = .defaultTheme.background
    let invisibleCharactersColor: UIColor = .defaultTheme.comment
    let pageGuideHairlineColor: UIColor = .defaultTheme.foreground.withAlphaComponent(0.1)
    let pageGuideBackgroundColor: UIColor = .defaultTheme.foreground.withAlphaComponent(0.2)
    let markedTextBackgroundColor: UIColor = .defaultTheme.foreground.withAlphaComponent(0.2)

    func textColor(for highlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(highlightName) else {
            return nil
        }
        return getColor(for: highlightName)
    }

    func getColor(for highlightName: HighlightName) -> UIColor? {
        switch highlightName {
        case .comment:
            return .defaultTheme.comment
        case .constructor:
            return .defaultTheme.yellow
        case .function:
            return .defaultTheme.blue
        case .keyword, .type:
            return .defaultTheme.purple
        case .number, .constantBuiltin, .constantCharacter:
            return .defaultTheme.orange
        case .property:
            return .defaultTheme.aqua
        case .string:
            return .defaultTheme.green
        case .variableBuiltin:
            return .defaultTheme.red
        case .operator, .punctuation:
            return .defaultTheme.foreground.withAlphaComponent(0.75)
        case .variable:
            return nil
        }
    }

    func fontTraits(for highlightName: String) -> FontTraits {
        guard let highlightName = HighlightName(highlightName) else {
            return []
        }
        if highlightName == .keyword {
            return .bold
        } else {
            return []
        }
    }
}

extension UIColor {
    // define custom themes here
    struct DefaultTheme {
        var background: UIColor {
            .white
        }
        var selection: UIColor {
            UIColor(red: 222 / 255, green: 222 / 255, blue: 222 / 255, alpha: 1)
        }
        var currentLine: UIColor {
            UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
        }
        var foreground: UIColor {
            UIColor(red: 96 / 255, green: 96 / 255, blue: 95 / 255, alpha: 1)
        }
        var comment: UIColor {
            UIColor(red: 159 / 255, green: 161 / 255, blue: 158 / 255, alpha: 1)
        }
        var red: UIColor {
            UIColor(red: 196 / 255, green: 74 / 255, blue: 62 / 255, alpha: 1)
        }
        var orange: UIColor {
            UIColor(red: 236 / 255, green: 157 / 255, blue: 68 / 255, alpha: 1)
        }
        var yellow: UIColor {
            UIColor(red: 232 / 255, green: 196 / 255, blue: 66 / 255, alpha: 1)
        }
        var green: UIColor {
            UIColor(red: 136 / 255, green: 154 / 255, blue: 46 / 255, alpha: 1)
        }
        var aqua: UIColor {
            UIColor(red: 100 / 255, green: 166 / 255, blue: 173 / 255, alpha: 1)
        }
        var blue: UIColor {
            UIColor(red: 94 / 255, green: 133 / 255, blue: 184 / 255, alpha: 1)
        }
        var purple: UIColor {
            UIColor(red: 149 / 255, green: 115 / 255, blue: 179 / 255, alpha: 1)
        }

        fileprivate init() {}
    }

    static let defaultTheme = DefaultTheme()
}
