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
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var assessment: AssessmentViewModel
    @EnvironmentObject var umlVM: UMLViewModel

    @StateObject var vm = ProblemStatementCellViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Problem Statement")
                .font(.largeTitle)

            ZStack {
                Divider()
                    .frame(height: 5)
                    .overlay(.gray)
                HStack {
                    ForEach(vm.bundledTests, id: \.testCase) { bundledTest in
                        if bundledTest != vm.bundledTests.first {
                            Spacer()
                        }
                        if bundledTest.passed {
                            Image("TestPassedSymbol")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .background(Color(.systemBackground))
                        } else {
                            Image("TestFailedSymbol")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .background(Color(.systemBackground))
                        }
                    }
                }
            }

            ForEach(vm.problemStatementParts, id: \.text) { part in
                if let puml = part as? ProblemStatementPlantUML {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            umlVM.imageURL = puml.url?.absoluteString
                            umlVM.showUMLFullScreen.toggle()
                        }
                    }, label: {
                        AsyncImage(url: puml.url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    })
                } else {
                    Markdown(part.text)
                        .setImageHandler(.assetImage(), forURLScheme: "asset")
                }
            }

        }
        .padding()
        .onAppear {
            vm.convertProblemStatement(
                problemStatement: assessment.submission?.participation.exercise.problemStatement ?? "",
                feedbacks: assessment.feedback.feedbacks,
                colorScheme: colorScheme)
        }
    }
}

struct ProblemStatementCellView_Previews: PreviewProvider {
    static let assessment = AssessmentViewModel(readOnly: false)

    static var previews: some View {
        ProblemStatementCellView()
            .environmentObject(assessment)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
