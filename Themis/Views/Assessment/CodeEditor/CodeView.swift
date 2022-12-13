import SwiftUI
import TreeSitterJavaRunestone
import TreeSitterSwiftRunestone
import Runestone
import UIKit

// integrates the UITextView of runestone in SwiftUI
struct CodeView: UIViewControllerRepresentable {
    @EnvironmentObject var cvm: CodeEditorViewModel
    @ObservedObject var file: Node

    @State private var isCurrentlyUpdatingView = ReferenceTypeBool(value: false)

    typealias UIViewControllerType = ViewController
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController(cvm: cvm)
        viewController.textView.editorDelegate = context.coordinator
        viewController.file = file
        return viewController
    }

    @MainActor
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        isCurrentlyUpdatingView.value = true
        defer {
            isCurrentlyUpdatingView.value = false
        }
        uiViewController.fontSize = cvm.editorFontSize
        // fixes content not being visisble if last files offset is higher than current content
        // (TODO: store content offsets of opened files e.g. in dictionary)
        if uiViewController.file != file {
            uiViewController.textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        uiViewController.file = file
        uiViewController.textView.highlightedRanges = cvm.inlineHighlights[file.path] ?? []
        if let range = cvm.scrollToRange.value {
            scrollToRange(viewController: uiViewController, range: range)
            cvm.scrollToRange.value = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func scrollToRange(viewController: ViewController, range: NSRange) {
        // TODO: fix container height = 0 when first opened
        // TODO: get actual content size (lazy scrollview results in dynamic content size)
        let contentHeight = viewController.textView.contentSize.height
        let containerHeight = viewController.textView.bounds.height
        if contentHeight > containerHeight {
            // hack to get UITextRange
            viewController.textView.selectedRange = range
            let textRange = viewController.textView.selectedTextRange
            viewController.textView.selectedRange = NSRange(location: 0, length: 0)

            if let textRange = textRange {
                let rangeOffsetY = viewController.textView.firstRect(for: textRange).origin.y
                // handle cases where offsetting it to the center is not wanted
                // otherwise the scrollview would jump back on next interaction since min/max scroll range is exceeded
                if rangeOffsetY < (containerHeight / 2) {
                    viewController.textView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                } else if (contentHeight - rangeOffsetY) < (containerHeight / 2) {
                    let bottomOffsetY = contentHeight - containerHeight
                    viewController.textView.setContentOffset(CGPoint(x: 0, y: bottomOffsetY), animated: true)
                } else {
                    viewController.textView.setContentOffset(CGPoint(x: 0, y: rangeOffsetY - (containerHeight / 2)), animated: true)
                }
            }
        }
    }

    class Coordinator: NSObject, TextViewDelegate {
        var parent: CodeView

        init(_ parent: CodeView) {
            self.parent = parent
        }

        @MainActor
        func textViewDidChangeSelection(_ textView: TextView) {
            if parent.isCurrentlyUpdatingView.value {
                return
            }
            if textView.selectedRange.length > 0 {
                parent.cvm.currentlySelecting = true
                parent.cvm.selectedSection = textView.selectedRange
            } else {
                parent.cvm.currentlySelecting = false
            }
        }
    }
}

// view controller that manages runestone UITextView
class ViewController: UIViewController {
    let cvm: CodeEditorViewModel
    let textView = TextView()
    let generator = UIImpactFeedbackGenerator(style: .light)

    var fontSize = 14.0 {
        didSet {
            if textView.theme.font.pointSize != fontSize {
                textView.setState(TextViewState(text: textView.text,
                                                theme: ThemeSettings(font: .systemFont(ofSize: fontSize))))
                applySyntaxHighlighting(on: textView)
            }
        }
    }
    var file: Node? {
        didSet {
            if textView.text != file?.code {
                applySyntaxHighlighting(on: textView)
            }
        }
    }

    init(cvm: CodeEditorViewModel) {
        self.cvm = cvm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        textView.translatesAutoresizingMaskIntoConstraints = false
        setCustomization(on: textView)
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setupLongPressInteraction()
    }

    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        self.cvm.showAddFeedback.toggle()
        generator.impactOccurred() // haptic feedback
    }

    private func setCustomization(on textView: TextView) {
        textView.backgroundColor = .systemBackground
        textView.lineHeightMultiplier = 1.3
        textView.showLineNumbers = true
        textView.showSpaces = false
        textView.showLineBreaks = false
        textView.isLineWrappingEnabled = true
        textView.isEditable = false
        textView.lineBreakMode = .byWordWrapping
    }

    private func applySyntaxHighlighting(on textView: TextView) {
        if let file = file, let code = file.code {
            switch file.fileExtension {
            case .swift:
                textView.setState(TextViewState(text: code, theme: ThemeSettings(font: .systemFont(ofSize: fontSize)), language: .swift))
            case .java:
                textView.setState(TextViewState(text: code, theme: ThemeSettings(font: .systemFont(ofSize: fontSize)), language: .java))
            case .other:
                textView.setState(TextViewState(text: code, theme: ThemeSettings(font: .systemFont(ofSize: fontSize))))
            }
        }
    }
    private func setupLongPressInteraction() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        textView.addGestureRecognizer(longPressGestureRecognizer)
    }
}

extension CodeView {
    private class ReferenceTypeBool {
        var value: Bool

        init(value: Bool) {
            self.value = value
        }
    }
}
