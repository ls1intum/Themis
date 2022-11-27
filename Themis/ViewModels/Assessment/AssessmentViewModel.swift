import Foundation
import SwiftUI
import Combine

class AssessmentViewModel: ObservableObject {
    @Published var fileTree: [Node] = []
    @Published var openFiles: [Node] = []
    @Published var selectedFile: Node?
    @Published var editorFontSize = CGFloat(14) // Default font size
    var submission: SubmissionForAssessment? // SubmissionForAssessment(id: 0, participation: SubmissionParticipation(id: 0, repositoryUrl: "", userIndependentRepositoryUrl: ""))

    var dismissPublisher = PassthroughSubject<Bool, Never>()
    private var dismissView = false {
        didSet {
            DispatchQueue.main.async {
                self.dismissPublisher.send(self.dismissView)
            }
        }
    }

    func openFile(file: Node) {
        if !openFiles.contains(where: { $0.path == file.path }) {
            openFiles.append(file)
            if let pId = submission?.participation.id {
                Task {
                    try await file.fetchCode(participationId: pId)
                }
            }
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

    func initRandomSubmission(exerciseId: Int) async {
        do {
            self.submission = try await ArtemisAPI.getRandomSubmissionForAssessment(exerciseId: 5284)
            guard let submission = submission else {
                self.dismissView = true
                return
            }
            let files = try await ArtemisAPI.getFileNamesOfRepository(participationId: submission.participation.id)
            let node = ArtemisAPI.initFileTreeStructure(files: files)
            DispatchQueue.main.async {
                self.fileTree = node.children ?? []
            }
        } catch {
            print(error)
            self.dismissView = true
            return
        }
    }

}
