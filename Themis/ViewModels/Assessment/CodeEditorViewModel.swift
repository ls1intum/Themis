//
//  CodeEditorViewModel.swift
//  Themis
//
//  Created by Andreas Cselovszky on 27.11.22.
//

import Foundation
import Runestone

class CodeEditorViewModel: ObservableObject {
    @Published var fileTree: [Node] = []
    @Published var openFiles: [Node] = []
    @Published var selectedFile: Node?
    @Published var editorFontSize = CGFloat(14) // Default font size
    @Published var currentlySelecting: Bool = false
    @Published var selectedLineNumber: Int?

    func incrementFontSize() {
        editorFontSize += 1
    }

    func decrementFontSize() {
        if editorFontSize > 8 { editorFontSize -= 1 }
    }

    func openFile(file: Node, participationId: Int) {
        if !openFiles.contains(where: { $0.path == file.path }) {
            openFiles.append(file)
            Task {
                try await file.fetchCode(participationId: participationId)
            }
        }
        selectedFile = file
    }

    func applySyntaxHighlighting(on textView: TextView) {
        if let selectedFile = selectedFile, let code = selectedFile.code {
            switch selectedFile.fileExtension {
            case .swift:
                textView.setLanguageMode(TreeSitterLanguageMode(language: .swift), completion: { _ in
                    textView.text = code })
            case .java:
                textView.setLanguageMode(TreeSitterLanguageMode(language: .java), completion: { _ in
                    textView.text = code })
            case .other:
                textView.setLanguageMode(PlainTextLanguageMode(), completion: { _ in
                    textView.text = code })
            }
        }
    }

    func closeFile(file: Node) {
        openFiles = openFiles.filter({ $0.path != file.path })
        selectedFile = openFiles.first
    }

    func initFileTree(participationId: Int) async {
        do {
            let files = try await ArtemisAPI.getFileNamesOfRepository(participationId: participationId)
            let node = ArtemisAPI.initFileTreeStructure(files: files)
            DispatchQueue.main.async {
                self.fileTree = node.children ?? []
            }
        } catch {
            print(error)
        }
    }

}
