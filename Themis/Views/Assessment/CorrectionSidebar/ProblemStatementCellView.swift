//
//  ProblemStatementView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import Foundation
import MarkdownUI

struct ProblemStatementCellView: View {
    @ObservedObject var model: ProblemStatementCellViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 40) {
                Text("Problem Statement")
                    .font(.largeTitle)

                ForEach(model.problemStatementParts) { problemStatementPart in
                    if let problemStatementPart = problemStatementPart.part as? String {
                        Markdown(problemStatementPart)
                    } else if let imageData = problemStatementPart.part as? Data {
                        Image(uiImage: UIImage(data: imageData)!)
                    }
                }
            }
        }.padding()
    }
}

struct ProblemStatementCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemStatementCellView(model: ProblemStatementCellViewModel.mock)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
