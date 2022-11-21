import Foundation
import SwiftUI

class AssessmentViewModel: ObservableObject {
    @Published var fileTree: [Node] = []
    @Published var openFiles: [Node] = []
    @Published var selectedFile: Node?
    @Published var editorFontSize = CGFloat(14) // Default font size

    init(files: [String: FileType]) {
        let node = ArtemisAPI.initFileTreeStructure(files: files)
        self.fileTree = node.children ?? []
    }

    func openFile(file: Node) {
        if !openFiles.contains(where: { $0.path == file.path }) {
            openFiles.append(file)
            file.fetchCode()
        }
        selectedFile = file
    }

    func closeFile(file: Node) {
        openFiles = openFiles.filter({ $0.path != file.path })
        selectedFile = openFiles.first
    }

    func incrementFontSize() {
        editorFontSize += 1
    }

    func decrementFontSize() {
        if editorFontSize > 8 { editorFontSize -= 1 }
    }

    static let mockData = [
        CodeFile(id: UUID(),
                 title: "Baum.java",
                 code: "class Baum {\n\tString type = \"Eiche\";\n}"),
        CodeFile(id: UUID(),
                 title: "Wald.java",
                 code: "class Wald {\n}"),
        CodeFile(id: UUID(),
                 title: "Fluss.java",
                 code: "class Fluss {\n}")
    ]
    
    static let newMockData: [String:FileType] = [
        "": .folder,
        "gradlew": .file,
        "settings.gradle": .file,
        "src/de/tum/themis/MergeSort.java": .file,
        "src": .folder,
        "gradle/wrapper/gradle-wrapper.jar": .file,
        "src/de/tum/themis": .folder,
        "gradle/wrapper/gradle-wrapper.properties": .file,
        "gradle/wrapper": .folder,
        "gradlew.bat": .file,
        "gradle": .folder,
        "src/de/tum": .folder,
        "build.gradle": .file,
        "src/de/tum/themis/Wald.java": .file,
        "src/de/tum/themis/Baum.java": .file,
        "src/de/tum/themis/Fluss.java": .file,
        "src/de": .folder
    ]

    public static var mock: AssessmentViewModel {
        let mock = AssessmentViewModel(files: newMockData)
        return mock
    }
}
