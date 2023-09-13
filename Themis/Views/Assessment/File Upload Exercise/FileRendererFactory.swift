//
//  FileRendererFactory.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.09.23.
//

import SwiftUI

enum FileRendererFactory {
    @ViewBuilder
    static func renderer(for localFileUrl: URL) -> some View {
        PDFRenderer(url: localFileUrl)
    }
}
