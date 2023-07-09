//
//  UMLRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import SwiftUI
import SharedModels
import Common

struct UMLRenderer: View {
    @StateObject private var umlRendererVM = UMLRendererViewModel()
    var modelString: String
    
    var body: some View {
        Group {
            Canvas(opaque: true, renderer: umlRendererVM.render(_:size:))
                .onTapGesture { tapLocation in
                    print(umlRendererVM.getElementAt(point: tapLocation)?.name)
                }
        }
        .onAppear {
            umlRendererVM.setup(modelString: modelString)
        }
    }
}

struct UMLRenderer_Previews: PreviewProvider {
    static var previews: some View {
        UMLRenderer(modelString: (Submission.mockModeling.baseSubmission as? ModelingSubmission)?.model ?? "nil")
    }
}
