//
//  Repository.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

enum FileType: String, Codable {
    case folder = "FOLDER"
    case file = "FILE"
}

/// support for additional languages can be added in the future
/// just by adding them here
enum FileExtension: String, Codable {
    case java = "JAVA"
    case swift = "SWIFT"
    case other = "OTHER"
}

class Node: Hashable, ObservableObject {

    var parent: Node?
    var name: String

    let type: FileType
    var children: [Node]?
    @Published var code: String?
    var templateCode: String?
    @Published var diffLinesAdded: [Int] = [] // line numbers of changed lines starting from 1
    @Published var diffLinesRemoved: [Int] = []
    private var diffCalculated = false
    /// property that calculates a lines character range to get line number of selectedTextRange
    var lines: [NSRange]? {
        if let code = code {
            var startIndex = 0
            var lines: [NSRange] = []
            let entries = code.components(separatedBy: .newlines)
            entries.forEach { line in
                // the string.components function removes the newline characters so we need to add 1 to get the coorect LineRanges
                lines.append(NSRange(location: startIndex, length: line.count + 1))
                startIndex += line.count + 1
            }
            return lines
        } else {
            return nil
        }
    }
    var fileExtension: FileExtension {
        let components = name.components(separatedBy: ".")
        let extensionString = components.last ?? ""
        if let ext = FileExtension(rawValue: extensionString.uppercased()) {
            return ext
        }
        return .other
    }

    init(type: FileType, name: String) {
        self.name = name
        self.type = type
    }

    convenience init(type: FileType, name: String, parent: Node) {
        self.init(type: type, name: name)
        self.parent = parent
    }

    var description: String {
        var desc = "\(name)"
        if let children {
            for child in children {
                desc += child.prettyPrint(spaces: "  ")
            }
        }
        return desc.trimmingCharacters(in: .newlines)
    }

    var path: String {
        calculatePath().joined(separator: "/")
    }

    /// This Method will flatMap children that have only one folder
    func flatMap() {
        guard let children, type == .folder else { return }
        if let childFolder = children.first, childFolder.type == .folder, children.count == 1 {
            self.name += "/" + childFolder.name // WTF Swiftlint enforece to use += lol
            self.children?.removeFirst()
            self.children = childFolder.children
            self.children?.forEach { child in
                child.parent = self
            }
            self.flatMap()
        } else {
            for child in children {
                child.flatMap()
            }
        }
    }

    private func calculatePath() -> [String] {
        var parentPath = parent?.calculatePath() ?? []
        parentPath.append(name)
        return parentPath
    }

    private func prettyPrint(spaces: String) -> String {
        var desc = ""
        let newSpaces = spaces + "  "
        print("\(spaces)\(name) - \(type.rawValue) - \(self.path)")
        guard let children else { return desc }
        for child in children {
            desc += child.prettyPrint(spaces: newSpaces) + "\n"
        }
        return desc
    }

    @MainActor
    public func fetchCode(participationId: Int) async {
        if code != nil { return } else {
            do {
                var relativePath = path
                relativePath.remove(at: relativePath.startIndex)
                self.code = try await ArtemisAPI.getFileOfRepository(participationId: participationId, filePath: relativePath)
            } catch {
                print(error)
            }
        }
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.path == rhs.path
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }

    @MainActor
    public func calculateDiff(templateParticipationId: Int) async {
        // only calculate once
        if diffCalculated {
            return
        }
        guard let code = self.code else {
            return
        }
        diffCalculated = true
        if templateCode == nil {
            await fetchTemplateCode(templateParticipationId: templateParticipationId)
        }
        guard let tcode = templateCode else {
            diffCalculated = false
            return
        }
        let base = tcode.components(separatedBy: .newlines)
        let new = code.components(separatedBy: .newlines)

        let diff = new.difference(from: base)
        var added = [Int]()
        var removed = [Int]()
        diff.forEach { change in
            switch change {
            case .insert(offset: let offset, element: _, associatedWith: _):
                added.append(offset + 1) // +1 as lines are starting from 1
            case .remove(offset: let offset, element: _, associatedWith: _):
                removed.append(offset + 1)
            }
        }
        self.diffLinesAdded = added
        self.diffLinesRemoved = removed
        print("added: \(diffLinesAdded)") // print as long as no highlighting exists
        print("removed: \(diffLinesRemoved)")
    }

    private func fetchTemplateCode(templateParticipationId: Int) async {
        if templateCode != nil { return } else {
            do {
                let relativePath = String(path.dropFirst())
                self.templateCode = try await ArtemisAPI.getFileOfRepository(participationId: templateParticipationId, filePath: relativePath)
            } catch {
                print(error)
            }
        }
    }
}

extension ArtemisAPI {

    /// Gets all file names from repository of submission with participationId.
    static func getFileNamesOfRepository(participationId: Int) async throws -> [String: FileType] {
        let request = Request(method: .get, path: "/api/repository/\(participationId)/files")
        return try await sendRequest([String: FileType].self, request: request)
    }

    /// Gets file of filePath from repository of submission with participationId. Response type: String.
    static func getFileOfRepository(participationId: Int, filePath: String) async throws -> String {
        let request = Request(method: .get, path: "/api/repository/\(participationId)/file", params: [URLQueryItem(name: "file", value: filePath)])
        return try await sendRequest(String.self, request: request) {
            String(decoding: $0, as: UTF8.self)
        }
    }

    /// Gets alls files with content from repository of submission with participationId. Response type: [String: String]
    static func getAllFilesOfRepository(participationId: Int) async throws -> [String: String] {
        let request = Request(method: .get, path: "/api/repository/\(participationId)/files-content")
        return try await sendRequest([String: String].self, request: request)
    }

    static func initFileTreeStructure(files: [String: FileType]) -> Node {

        let convertedStructure = files.sorted { $0.key < $1.key }
            .map {
                guard let path = URL(string: $0.key) else {
                    return ([""], $0.value)
                }
                return (path.pathComponents, $0.value)
            }
            .filter { $0.0 != [""] }
            .map { (path: Stack(storage: $0.0.reversed()), type: $0.1) }

        let root = Node(type: .folder, name: "")
        let start = DispatchTime.now()
        parseFileTree(node: root, paths: convertedStructure)
        let end = DispatchTime.now()

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Time to evaluate Parse: \(timeInterval) seconds")
        root.flatMap()
        return root
    }

    static func parseFileTree(node: Node, paths: [(path: Stack<String>, type: FileType)]) {
        let root = paths.filter { $0.path.size() == 1 }.map { (name: $0.path.pop()!, type: $0.type) }
        var notRoot = paths.filter { $0.path.size() > 0 }
        for elem in root {
            if elem.type == .file {
                if node.children == nil { node.children = [] }
                node.children?.append(Node(type: .file, name: elem.name, parent: node))
            } else {
                let newFolder = Node(type: .folder, name: elem.name, parent: node)
                let children = notRoot.filter { $0.path.peek() == elem.name }
                children.forEach { child in
                    _ = child.path.pop()
                    notRoot.removeAll { parent in parent.path === child.path }
                }
                // notRoot.removeAll { p in children.contains { $0.path === p.path } }
                parseFileTree(node: newFolder, paths: children)
                if node.children == nil { node.children = [] }
                node.children?.append(newFolder)
            }
        }
    }
}
