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
    
    @StateObject var problemStatementCellVM = ProblemStatementCellViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Problem Statement")
                .font(.largeTitle)
            
            testResultsBar
            
            problemStatementBody
        }
        .padding()
        .task(id: problemStatement) {
            problemStatementCellVM.convertProblemStatement(
                problemStatement: problemStatement,
                feedbacks: feedbacks,
                colorScheme: colorScheme)
        }
    }
    
    private var testResultsBar: some View {
        ZStack {
            Divider()
                .frame(height: 5)
                .overlay(.gray)
            HStack {
                ForEach(problemStatementCellVM.bundledTests, id: \.testCase) { bundledTest in
                    if bundledTest != problemStatementCellVM.bundledTests.first {
                        Spacer()
                    }
                    if bundledTest.passed {
                        Image("TestPassedSymbol")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                    } else {
                        Image("TestFailedSymbol")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                            .background(Color("sidebarBackground"))
                    }
                }
            }
        }
    }
    
    private var problemStatementBody: some View {
        ForEach(problemStatementCellVM.problemStatementParts, id: \.text) { part in
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
                    .markdownInlineImageProvider(.asset)
            }
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
