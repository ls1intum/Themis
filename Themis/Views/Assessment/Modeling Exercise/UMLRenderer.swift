//
//  UMLRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import SwiftUI
import SharedModels
import Common
import ApollonView
import ApollonShared

struct UMLRenderer: View {
    @ObservedObject var umlRendererVM: UMLRendererViewModel

    var body: some View {
        ZStack {
            if let model = umlRendererVM.umlModel, let type = model.type {
                ApollonView(umlModel: model,
                            diagramType: type,
                            fontSize: umlRendererVM.fontSize,
                            themeColor: Color.Artemis.artemisBlue,
                            diagramOffset: umlRendererVM.offset,
                            isGridBackground: true) {
                    Canvas(rendersAsynchronously: true) { context, size in
                        umlRendererVM.renderHighlights(&context, size: size)
                    } symbols: {
                        umlRendererVM.generatePossibleSymbols()
                    }
                    .onTapGesture { tapLocation in
                        umlRendererVM.selectItem(at: tapLocation)
                    }
                }
            }
        }
    }
}

struct UMLRenderer_Previews: PreviewProvider {
    static var umlRendererVM = UMLRendererViewModel()

    static var previews: some View {
        UMLRenderer(umlRendererVM: umlRendererVM)
            .onAppear {
                umlRendererVM.setup(basedOn: Submission.mockModeling.baseSubmission, AssessmentResult())
            }
    }
}
