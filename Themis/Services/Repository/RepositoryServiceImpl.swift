//
//  RepositoryServiceImpl.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.05.23.
//

import Foundation
import SharedModels
import APIClient
import DesignLibrary

class RepositoryServiceImpl: RepositoryService {
    
    let client = APIClient()

    // MARK: - Get File Names
    private struct GetFileNamesRequest: APIRequest {
        typealias Response = [String: FileType]
        
        var participationId: Int
        
        var method: HTTPMethod {
            .get
        }
        
        var resourceName: String {
            "api/repository/\(participationId)/files"
        }
    }
    
    func getFileNamesOfRepository(participationId: Int) async throws -> [String: FileType] {
        try await client.sendRequest(GetFileNamesRequest(participationId: participationId)).get().0
    }
    
    // MARK: - Get File of Repository
    private struct GetFileOfRepositoryRequest: APIRequest {
        typealias Response = RawResponse
        
        var participationId: Int
        var filePath: String

        var method: HTTPMethod {
            .get
        }
        
        var params: [URLQueryItem] {
            [URLQueryItem(name: "file", value: filePath)]
        }
        
        var resourceName: String {
            "api/repository/\(participationId)/file"
        }
    }
    
    func getFileOfRepository(participationId: Int, filePath: String) async throws -> String {
        try await client.sendRequest(GetFileOfRepositoryRequest(participationId: participationId, filePath: filePath)).get().0.rawData
    }
}
