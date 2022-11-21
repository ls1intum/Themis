//
//  ExportRepository.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

enum FileType: String, Codable {
    case folder = "FOLDER"
    case file = "FILE"
}

class Node: Hashable {
    
    var parent: Node?
    var name: String
    
    let type: FileType
    var children: [Node]?
    var code: String?
    
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
            desc += child.prettyPrint(spaces: newSpaces)  + "\n"
        }
        return desc
    }
    
    public func fetchCode() {
        if code != nil { return }
        else {
            ///MOCK STUFF
            switch name {
            case "Baum.java": self.code = "class Baum {\n\tString type = \"Eiche\";\n}"
            case "Wald.java": self.code = "class Wald {\n}"
            case "Fluss.java": self.code = "class Fluss {\n}"
            default: self.code = "class DEFAULT {\n}"
            }
        }
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.path == rhs.path
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
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
    
    static func initFileTreeStructure(files: [String:FileType]) -> Node {
        
        let convertedDict = Dictionary(uniqueKeysWithValues: files.map { key, value in
            guard let path = URL(string: key) else { return ([""], value)}
            return (path.pathComponents, value)
        })
        .filter { $0.key != [""] }
        .map { (path: Stack(storage: $0.key.reversed()), type: $0.value) }
        
        
        let root = Node(type: .folder, name: "")
        let start = DispatchTime.now()
        parseFileTree(node: root, paths: convertedDict)
        let end = DispatchTime.now()

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000

        print("Time to evaluate Parse: \(timeInterval) seconds")
        
        return root
    }
    
    static func parseFileTree(node: Node, paths: [(path: Stack<String>, type: FileType)])  {
        let root = paths.filter { $0.path.size() == 1 }.map { (name: $0.path.pop()!, type: $0.type) }
        var notRoot = paths.filter { $0.path.size() > 0 }
        for elem in root {
            if elem.type == .file {
                if node.children == nil { node.children = [] }
                node.children?.append(Node(type: .file, name: elem.name, parent: node))
            } else {
                let newFolder = Node(type: .folder, name: elem.name, parent: node)
                let children = notRoot.filter { $0.path.peek() == elem.name }
                children.forEach { c in
                    let _ = c.path.pop()
                    notRoot.removeAll { p in p.path === c.path }
                }
                //notRoot.removeAll { p in children.contains { $0.path === p.path } }
                parseFileTree(node: newFolder, paths: children)
                if node.children == nil { node.children = [] }
                node.children?.append(newFolder)
            }
        }
    }
   
}

