import SwiftUI
import CodeEditor

struct CodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var dragSelection: Range<Int>?
    @State var line: Line?
    var onOpenFeedback: (Range<Int>) -> Void

    var body: some View {
        ZStack {
            CodeEditor(source: file.code ?? "loading...",
                       language: .swift,
                       theme: theme,
                       fontSize: $fontSize,
                       flags: editorFlags,
                       highlightedRanges: cvm.inlineHighlights[file.path] ?? [],
                       dragSelection: $dragSelection,
                       line: $line,
                       showAddFeedback: $cvm.showAddFeedback,
                       selectedSection: $cvm.selectedSection)
            if let line {
                DrawingShape(points: line.points)
                    .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
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
        }).onEnded { _ in
            if let dragSelection {
                onOpenFeedback(dragSelection)
            }
            dragSelection = nil
            line = nil
        })
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

/// used for testing editmenu
 struct CodeViewSelect: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var file: Node
    @Binding var fontSize: CGFloat
    @State var dragSelection: Range<Int>?
    @State var line: Line?
    var onOpenFeedback: (Range<Int>) -> Void

    var body: some View {
        ZStack {
            CodeEditor(source: file.code ?? "loading...",
                       language: .swift,
                       theme: theme,
                       fontSize: $fontSize,
                       flags: editorFlags,
                       highlightedRanges: cvm.inlineHighlights[file.path] ?? [],
                       dragSelection: $dragSelection,
                       line: $line,
                       showAddFeedback: $cvm.showAddFeedback,
                       selectedSection: $cvm.selectedSection)
        }
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
