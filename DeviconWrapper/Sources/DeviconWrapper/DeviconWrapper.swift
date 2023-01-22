import SwiftUI
import SVGView

public enum LanguageIcon: String {
    case swift = "swift"
    case python = "python"
    case c = "c"
    case rust = "rust"
    case java = "java"
}

public enum Style: String {
    case original
    case plain
}

public struct IconFinder {
    
    public init() {
        
    }
    
    private let iconDict: [String: LanguageIcon] = [
        "c" : .c,
        "py" : .python,
        "java" : .java,
        "swift" : .swift,
        "rs" : .rust
    ]
    
    public func icon(for fileExtension: String, style: Style) -> SVGView? {
        guard let language = iconDict[fileExtension] else { return nil }
        return icon(for: language, style: style)
    }
    
    public func icon(for language: LanguageIcon, style: Style) -> SVGView {
        let path = getURLString(for: language, style: style)
        guard let url = Bundle.module.url(forResource: path, withExtension: "svg") else {
            print("URL not found")
            return fallbackIcon(for: language, style: style == .plain ? .original : .plain)
        }
        return SVGView(contentsOf: url)
    }
    
    private func fallbackIcon(for language: LanguageIcon, style: Style) -> SVGView {
        let path = getURLString(for: language, style: style)
        guard let url = Bundle.module.url(forResource: path, withExtension: "svg") else {
            return SVGView(string: "")
        }
        return SVGView(contentsOf: url)
    }
    
    private func getURLString(for language: LanguageIcon, style: Style) -> String {
        return "Resources/devicon/icons/\(language.rawValue)/\(language.rawValue)-\(style.rawValue)"
    }
    
}



