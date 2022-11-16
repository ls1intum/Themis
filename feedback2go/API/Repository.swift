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

/// Gets all file names from repository of submission with participationId. Response type: [String]
struct GetFileNamesFromRepository {
    let participationId: Int
    var request: Request {
        Request(method: .get, path: "/api/repository/\(participationId)/file-names")
    }
}

/// Gets file of filePath from repository of submission with participationId. Response type: String
struct GetFileOfRepository: APIRequest {
    let participationId: Int
    let filePath: String
    var request: Request {
        Request(method: .get, path: "/api/repository/\(participationId)/file?file=\(filePath)")
    }
}

struct GetAllFilesOfRepository: APIRequest {
    let participationId: Int
    var request: Request {
        Request(method: .get, path: "/api/repository/\(participationId)/files")
    }
}

