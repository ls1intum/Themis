import SwiftUI
import TreeSitterJavaRunestone
import Runestone
import UIKit

// integrates the UITextView of runestone in SwiftUI
struct CodeView: UIViewControllerRepresentable {
    @ObservedObject var vm: CodeEditorViewModel
    @ObservedObject var fvm: FeedbackViewModel

    typealias UIViewControllerType = ViewController
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.textView.editorDelegate = context.coordinator
        viewController.sourceCode = vm.selectedFile?.code ?? ""
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.sourceCode = vm.selectedFile?.code ?? ""
        uiViewController.editorFontSize = vm.editorFontSize
        if let selectedFile = vm.selectedFile {
            uiViewController.textView.highlightedRanges = fvm.inlineHighlights[selectedFile.path] ?? []
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
                parent.vm.currentlySelecting = true
                parent.vm.selectedLineNumber = (parent.vm.selectedFile?.lines?.firstIndex {
                    $0.contains(textView.selectedRange.location)
                } ?? 0) + 1
            } else {
                parent.vm.currentlySelecting = false
            }
        }
    }
}

// view controller that manages runestone UITextView
class ViewController: UIViewController {
    let textView = TextView()
    // in a future version the language mode will dynamically adapt to the programming language of the exercise
    let languageMode = TreeSitterLanguageMode(language: .java)
    var sourceCode = "" {
        didSet {
            textView.text = sourceCode
        }
    }
    var editorFontSize = 14.0 {
        didSet {
            let state = TextViewState(text: sourceCode,
                                      theme: ThemeSettings(font: .systemFont(ofSize: editorFontSize)),
                                      language: .java)
            textView.setState(state)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        textView.text = sourceCode
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        setCustomization(on: textView)
        textView.setLanguageMode(languageMode)
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setCustomization(on textView: TextView) {
        textView.lineHeightMultiplier = 1.3
        textView.showLineNumbers = true
        textView.showSpaces = true
        textView.showLineBreaks = true
        textView.isLineWrappingEnabled = true
        textView.isEditable = false
        textView.lineBreakMode = .byWordWrapping
    }
}
