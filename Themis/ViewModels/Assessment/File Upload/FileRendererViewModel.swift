//
//  FileRendererViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 11.09.23.
//

import Foundation
import SharedModels
import UserStore
import Common

class FileRendererViewModel: ExerciseRendererViewModel {
    @Published var localFileURL: URL?
    @Published var isSetupComplete = false
    @Published var canDirectlyRenderFile = false
    
    var fileDownloadService = FileDownloadService()
    
    private let supportedFileExtensions = ["pdf"]
    
    /// Sets this VM up based on the given submission
    @MainActor
    func setup(basedOn submission: BaseSubmission? = nil) async {
        guard let fileUploadSubmission = submission as? FileUploadSubmission,
              let baseUrl = UserSession.shared.institution?.baseURL?.absoluteString,
              let filePath = fileUploadSubmission.filePath?.dropFirst(),
              let remoteFileUrl = URL(string: "\(baseUrl)\(filePath)") else {
            return
        }
        
        isLoading = true
        defer {
            isLoading = false
            isSetupComplete = true
        }
        
        canDirectlyRenderFile = supportedFileExtensions.contains(remoteFileUrl.pathExtension)
        guard canDirectlyRenderFile else {
            return
        }
        
        localFileURL = await fileDownloadService.download(from: remoteFileUrl)
    }
}
