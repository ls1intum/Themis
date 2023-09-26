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
            // We are not using QuickLook here because it allows sketching on the pages
            // This can make the user think that the sketches will be visible to the student as well
            PDFRenderer(url: url)
        case .doc, .docx, .xlsx, .csv, .txt, .png, .jpeg:
            QuickLookFileRenderer(url: url)
        default:
            UnsupportedFileView(url: url, fileExtension: fileExtension)
        }
    }
}

enum FileUploadExerciseFileExtension: String {
    case pdf, jpeg, png, doc, docx, xlsx, txt, csv, other
}

/// Intended for views that can be returned by FileRendererFactory
protocol FileRenderer {
    var url: URL { get }
}
