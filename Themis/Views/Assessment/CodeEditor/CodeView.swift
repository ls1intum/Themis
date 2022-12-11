import SwiftUI
import CodeEditor

struct CodeViewNew: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var dragSelection: Range<Int>?
    @State var line: Line?

    var body: some View {
        ZStack {
            CodeEditor(source: file.code ?? "loading...",
                       language: .swift,
                       theme: theme,
                       fontSize: $fontSize,
                       flags: editorFlags,
                       highlightedRanges: mockHighlights,
                       dragSelection: $dragSelection,
                       line: $line)
            if let line {
                DrawingShape(points: line.points)
                    .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
            let newPoint = value.location
            if value.translation.width + value.translation.height == 0 {
                self.line = Line(points: [newPoint], color: .blue, lineWidth: 10.0)
            } else {
                self.line?.points.append(newPoint)
            }
        }).onEnded { _ in
            print("Feedback hinzugefuegt! \(dragSelection)")
            dragSelection = nil
        }).onChange(of: dragSelection) { value in
            print("dragSelection changed to \(value)")
        }
    }

    var mockHighlights: [HighlightedRange] {
        return [HighlightedRange(range: NSRange(location: 10, length: 10), color: UIColor.yellow),
                HighlightedRange(range: NSRange(location: 30, length: 10), color: UIColor.red)]
    }

    var editorFlags: CodeEditor.Flags {
        if colorScheme == .dark {
            return .blackBackground
        } else {
            return .selectable
        }
    }

    var theme: CodeEditor.ThemeName {
        if colorScheme == .dark {
            return .ocean
        } else {
            return .xcode
        }
    }
}
