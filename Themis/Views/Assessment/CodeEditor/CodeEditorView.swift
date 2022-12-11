import SwiftUI
import CodeEditor

struct CodeEditorView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel
    @EnvironmentObject var cvm: CodeEditorViewModel

    @Binding var showFileTree: Bool

    var body: some View {
        VStack {
            if let file = cvm.selectedFile {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView()
                    }
                    CodeViewNew(file: file, fontSize: $cvm.editorFontSize)
                }
            } else {
                Text("Select a file")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

struct CodeViewNew: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var line: Line?
    @State var dragSelection: Range<String.Index> = ("_").lineRange(for: "".startIndex..."".endIndex)
    
    var body: some View {
        ZStack {
            CodeEditor(source: file.code ?? "loading...",
                       selection: $dragSelection,
                       language: .swift,
                       theme: theme,
                       fontSize: $fontSize,
                       flags: editorFlags,
                       highlightedRanges: mockHighlights,
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
        }))
    }
    
    var mockHighlights: [HighlightedRange] {
        return [HighlightedRange(range: NSMakeRange(10, 10), color: UIColor.yellow),
                HighlightedRange(range: NSMakeRange(30, 10), color: UIColor.red)]
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
