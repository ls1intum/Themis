//
//  QuickLookFileRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.09.23.
//

import SwiftUI
import DesignLibrary

struct QuickLookFileRenderer: View, FileRenderer {
    var url: URL
    
    var body: some View {
        QuickLookController(url: url)
    }
}

struct QuickLookFileRenderer_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        QuickLookFileRenderer(url: URL(string: "https://file-examples.com/wp-content/storage/2017/02/file-sample_100kB.doc")!)
    }
}
