import SwiftUI
import CodeEditor

struct CodeEditorView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    @Binding var showFileTree: Bool

    private func openFeedbackSheet(forRange dragRange: Range<Int>) {
        cvm.selectedSection = dragRange.toNSRange()
        cvm.showAddFeedback = true
    }

    var body: some View {
        VStack {
            if let file = cvm.selectedFile {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView()
                    }
                    CodeView(
                        file: file,
                        fontSize: $cvm.editorFontSize,
                        onOpenFeedback: openFeedbackSheet
                    )
                }
            } else {
                Text("Select a file")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

struct CodeViewNewTest: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat

    var body: some View {
        ZStack {
            CodeEditor(source: file.code ?? "loading...",
                       language: .swift,
                       theme: theme,
                       fontSize: $fontSize,
                       flags: editorFlags,
                       highlightedRanges: mockHighlights)
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

struct CodeViewNew: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var line: Line?
    @State var dragSelection: Range<Int>?

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
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}
