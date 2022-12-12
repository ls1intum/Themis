import SwiftUI
import TreeSitterJavaRunestone
import TreeSitterSwiftRunestone
import Runestone
import UIKit

// integrates the UITextView of runestone in SwiftUI
struct CodeView: UIViewControllerRepresentable {
    @EnvironmentObject var cvm: CodeEditorViewModel
    @ObservedObject var file: Node

    typealias UIViewControllerType = ViewController
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController(cvm: cvm)
        viewController.textView.editorDelegate = context.coordinator
        viewController.file = file
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.fontSize = cvm.editorFontSize
        uiViewController.file = file
        uiViewController.textView.highlightedRanges = cvm.inlineHighlights[file.path] ?? []
        if let scrollToRange = cvm.scrollToRange {
            uiViewController.textView.scrollRangeToVisible(scrollToRange)
            cvm.scrollToRange = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TextViewDelegate {
        var parent: CodeView

        init(_ parent: CodeView) {
            self.parent = parent
        }

        @MainActor
        func textViewDidChangeSelection(_ textView: TextView) {
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
