//
//  FileRendererFactory.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.09.23.
//

import SwiftUI

enum FileRendererFactory {
    @ViewBuilder
    static func renderer(for fileExtension: FileUploadExerciseFileExtension, at url: URL) -> some View {
        switch fileExtension {
        case .pdf:
            PDFRenderer(url: url)
        case .png, .jpeg:
            ImageFileRenderer(url: url)
        default:
            UnsupportedFileView(url: url, fileExtension: fileExtension)
        }
    }
}

enum FileUploadExerciseFileExtension: String {
    case pdf, jpeg, png, other
}
