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
    @Binding var problemStatement: String
    var feedbacks: [AssessmentFeedback]
    @ObservedObject var umlVM: UMLViewModel
    
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
            
            // Markdown("![This is an image](https://user-images.githubusercontent.com/373190/209442987-2aa9d73d-3bf2-46cb-b03a-5d9c0ab8475f.gif)")
            
            Markdown("2.\n\n![This is](TestFailedSymbol)\n\n**Context Class (2 of 2 tests passing)** ").markdownImageProvider(.asset)
            Markdown("2.\n ![This is](TestFailedSymbol) \n\n**Context Class (2 of 2 tests passing)** ").markdownImageProvider(.asset)
            Markdown("2.\n\n ![This is](TestFailedSymbol) \n**Context Class (2 of 2 tests passing)** ").markdownImageProvider(.asset)
            Markdown("2.  ![This is](TestFailedSymbol)  **Context Class (2 of 2 tests passing)** ").markdownImageProvider(.asset)
            Markdown("2.  ![This is](TestFailedSymbol) **Context Class (2 of 2 tests passing)** ").markdownImageProvider(.asset)
            Markdown("2. ![This is](TestFailedSymbol) **Context Class (2 of 2 tests passing)** ").markdownImageProvider(.asset)
            
            /*Markdown("2.\n\n ![This is](https://user-images.githubusercontent.com/373190/209442987-2aa9d73d-3bf2-46cb-b03a-5d9c0ab8475f.gif) \n\n**Context Class (2 of 2 tests passing)** ")
            Markdown("2.\n ![This is](https://user-images.githubusercontent.com/373190/209442987-2aa9d73d-3bf2-46cb-b03a-5d9c0ab8475f.gif) \n**Context Class (2 of 2 tests passing)** ")
                // .markdownImageProvider(.asset)
            /*Markdown("![This is an image](dog)")
                .markdownTextStyle(\.code) {
                    FontFamilyVariant(.monospaced)
                    ForegroundColor(.red)
                }
                .markdownImageProvider(.asset)
            Markdown("![This is an image](dog)")
                .markdownImageProvider(.asset)
            Markdown("![This is an image](dog)")
                .markdownImageProvider(.asset)
                .markdownTextStyle(\.code) {
                    FontFamilyVariant(.monospaced)
                    ForegroundColor(.red)
                }*/
            
            Markdown("2. ![This is](TestFailedSymbol) **Context Class (2 of 2 tests passing)** ")
                .markdownImageProvider(.asset)
                .markdownTextStyle(\.code) {
                    FontFamilyVariant(.monospaced)
                    ForegroundColor(.red)
                }
            
            Markdown("2. ![This is](TestFailedSymbol) **Context Class (2 of 2 tests passing)** ")
                .markdownImageProvider(.asset)*/
            
            ForEach(vm.problemStatementParts, id: \.text) { part in
                if let uml = part as? ProblemStatementPlantUML {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            umlVM.imageURL = uml.url?.absoluteString
                            umlVM.showUMLFullScreen.toggle()
                        }
                    }, label: {
                        AsyncImage(url: uml.url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    })
                } else {
                    Markdown(part.text)
                        .markdownTextStyle(\.code) {
                            FontFamilyVariant(.monospaced)
                            ForegroundColor(.red)
                        }
                        .markdownImageProvider(.asset)////
                }
            }
        }
        .padding()
        .task(id: problemStatement) {
            vm.convertProblemStatement(
                problemStatement: problemStatement,
                feedbacks: feedbacks,
                colorScheme: colorScheme)
        }
    }
}

struct ProblemStatementCellView_Previews: PreviewProvider {
    static var umlVM = UMLViewModel()
    static let feedbacks: [AssessmentFeedback] = []
    @State static var problemStatement: String = "test"
    
    static var previews: some View {
        ProblemStatementCellView(
            problemStatement: $problemStatement,
            feedbacks: feedbacks,
            umlVM: umlVM
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
