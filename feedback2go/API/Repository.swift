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
}
