import SwiftUI
import CodeEditor

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

struct CodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var dragSelection: Range<Int>?
    @State var line: Line?
    var onOpenFeedback: (Range<Int>) -> Void

    var editorItself: some View {
        CodeEditor(source: $file.code ?? "loading...",
                   language: .swift,
                   theme: theme,
                   fontSize: $fontSize,
                   flags: editorFlags,
                   highlightedRanges: cvm.inlineHighlights[file.path] ?? [],
                   dragSelection: $dragSelection,
                   line: $line,
                   showAddFeedback: $cvm.showAddFeedback,
                   showEditFeedback: $cvm.showEditFeedback,
                   selectedSection: $cvm.selectedSection,
                   feedbackForSelectionId: $cvm.feedbackForSelectionId,
                   scrollToRange: cvm.scrollToRange,
                   containerHeight: cvm.codeViewHeight)
    }
    
    var editorInLassoMode: some View {
        ZStack {
            editorItself
            if let line {
                DrawingShape(points: line.points)
                    .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                let newPoint = value.location
                if value.translation.width + value.translation.height == 0 {
                    self.line = Line(
                        points: [newPoint],
                        color: .orange.opacity(0.5),
                        lineWidth: 10.0
                    )
                } else {
                    self.line?.points.append(newPoint)
                }
            })
            .onEnded { _ in
                if let dragSelection {
                    onOpenFeedback(dragSelection)
                }
                dragSelection = nil
                line = nil
            })
    }
    
    var body: some View {
        if cvm.lassoMode {
            editorInLassoMode
        } else {
            editorItself
        }
    }

    var editorFlags: CodeEditor.Flags {
        if colorScheme == .dark {
            return [.selectable, .blackBackground]
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
