import SwiftUI
import TreeSitterJavaRunestone
import TreeSitterSwiftRunestone
import Runestone
import UIKit

// integrates the UITextView of runestone in SwiftUI
struct CodeView: UIViewControllerRepresentable {
    @EnvironmentObject var cvm: CodeEditorViewModel

    typealias UIViewControllerType = ViewController
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.textView.editorDelegate = context.coordinator
        cvm.applySyntaxHighlighting(on: viewController.textView)
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.fontSize = cvm.editorFontSize
        cvm.applySyntaxHighlighting(on: uiViewController.textView)
        if let selectedFile = cvm.selectedFile {
            uiViewController.textView.highlightedRanges = cvm.inlineHighlights[selectedFile.path] ?? []
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

        func textViewDidChangeSelection(_ textView: TextView) {
            if textView.selectedRange.length > 0 {
                parent.cvm.currentlySelecting = true
                parent.cvm.selectedLineNumber = (parent.cvm.selectedFile?.lines?.firstIndex {
                    $0.contains(textView.selectedRange.location)
                } ?? 0) + 1
            } else {
                parent.cvm.currentlySelecting = false
            }
        }
    }
}

// view controller that manages runestone UITextView
class ViewController: UIViewController {
    let textView = TextView()
    var fontSize = 14.0 {
        didSet {
            textView.setState(TextViewState(text: textView.text,
                                            theme: ThemeSettings(font: .systemFont(ofSize: fontSize))))
        }
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
    }

    private func setCustomization(on textView: TextView) {
        textView.backgroundColor = .systemBackground
        textView.lineHeightMultiplier = 1.3
        textView.showLineNumbers = true
        textView.showSpaces = true
        textView.showLineBreaks = true
        textView.isLineWrappingEnabled = true
        textView.isEditable = false
        textView.lineBreakMode = .byWordWrapping
    }
}
