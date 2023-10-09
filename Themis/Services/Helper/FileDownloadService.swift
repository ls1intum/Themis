//
//  FileDownloadService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.09.23.
//

import SwiftUI
import Common

class FileDownloadService: ObservableObject {
    
    /// Downloads the file from the given URL and returns a temporary local URL
    /// - Parameter url: the URL to download from
    /// - Returns: a temporary local URL where the file can be found
    @MainActor
    func download(from url: URL) async -> URL? {
        do {
            log.verbose("Started downloading from: \(url.absoluteString)")
            var (localDestinationUrl, httpResponse) = try await URLSession.shared.download(from: url)
            // TODO: Use unique file names for each submission. This will allow us to use existing files safely, without having to delete every time
            try rename(fileAt: &localDestinationUrl, to: httpResponse.suggestedFilename ?? url.lastPathComponent)
            log.verbose("Saved new file at: \(localDestinationUrl.absoluteString)")
            return localDestinationUrl
        } catch {
            log.error("Could not download file: \(String(describing: error))")
            return nil
        }
    }
    
    private func rename(fileAt currentUrl: inout URL, to name: String) throws {
        let newUrl = currentUrl.deletingLastPathComponent().appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: newUrl.path()) {
            // Removing in case the same file name is used in multiple submissions
            try FileManager.default.removeItem(at: newUrl)
        }
        
        try FileManager.default.moveItem(at: currentUrl, to: newUrl)
        currentUrl = newUrl
    }
}
