//
//  ExportRepository.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

private struct ExportOptions: Encodable {
    let anonymizeStudentCommits: Bool = true
    let hideStudentNameInZippedFolder: Bool = true
}

/// Gets the repository of submission with participationId as zip file
struct GetSubmissionRepository: APIRequest {
    let exerciseId: Int
    let participationId: Int
    var request: Request {
        Request(method: .post, path: "/api/programming-exercises/\(exerciseId)/export-repos-by-participation-ids/\(participationId)", body: ExportOptions())
    }
}

/// Gets the solution repository of the exercise with exerciseId as a zip file
struct GetSolutionRepository: APIRequest {
    let exerciseId: Int
    var request: Request {
        Request(method: .get, path: "/api/programming-exercises/\(exerciseId)/export-solution-repository")
    }
}

enum FileType: String, Codable {
    case folder = "FOLDER"
    case file = "FILE"
}

/// Gets all file names from repository of submission with participationId. Response type: [String: FileType]
struct GetFileNamesOfRepository: APIRequest {
    let participationId: Int
    var request: Request {
        Request(method: .get, path: "/api/repository/\(participationId)/files")
    }
}

/// Gets file of filePath from repository of submission with participationId. Response type: String
struct GetFileOfRepository: APIRequest {
    let participationId: Int
    let filePath: String
    var request: Request {
        Request(method: .get, path: "/api/repository/\(participationId)/file", params: [URLQueryItem(name: "file", value: filePath)])
    }
}

/// Gets alls files with content from repository of submission with participationId. Response type: [String: String]
struct GetAllFilesOfRepository: APIRequest {
    let participationId: Int
    var request: Request {
        Request(method: .get, path: "/api/repository/\(participationId)/files-content")
    }
}

