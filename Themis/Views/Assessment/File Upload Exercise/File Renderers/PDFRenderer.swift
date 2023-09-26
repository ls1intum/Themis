//
//  PDFRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 10.09.23.
//

import SwiftUI
import PDFKit

struct PDFRenderer: UIViewRepresentable, FileRenderer {
    
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<Self>) {}
}

struct PDFRenderer_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        PDFRenderer(url: Bundle.main.url(forResource: "proposal", withExtension: "pdf")!)
            .onAppear {
                print(FileManager.default.urls(for: .downloadsDirectory, in: .allDomainsMask))
            }
    }
}
