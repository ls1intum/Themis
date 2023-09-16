//
//  UnsupportedFileViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.09.23.
//

import Foundation
import Common

class UnsupportedFileViewModel: ObservableObject {
    @Published var isDownloading = false
    @Published var allowsDownloading = true
    @Published var localFileUrl: URL?
    
    var fileDownloadService = FileDownloadService()
    
    @MainActor
    func download(from remoteUrl: URL) {
        allowsDownloading = false
        
        Task {
            isDownloading = true
            defer { isDownloading = false }
            
            let localFileUrl = await fileDownloadService.download(from: remoteUrl)
            self.localFileUrl = localFileUrl
        }
    }
    
    private func getData(from localUrl: URL) -> Data? {
        do {
            let data = try Data(contentsOf: localUrl)
            return data
        } catch {
            log.error("Could not extract data from the downloaded file: \(String(describing: error))")
            return nil
        }
    }
}
