//
//  ProblemStatementCellModel.swift
//  Themis
//
//  Created by Florian Huber on 14.11.22.
//

// swiftlint:disable line_length

import Foundation
import SwiftUI

protocol ProblemStatementPart {
    var text: String { get }
}

struct ProblemStatementPlantUML: ProblemStatementPart {
    let text: String
    var url: URL? {
        var url = URL(string: "https://artemis-staging.ase.in.tum.de/api/plantuml/png")
        url?.append(queryItems: [URLQueryItem(name: "plantuml", value: text)])
        return url
    }
}

struct ProblemStatementMD: ProblemStatementPart {
    let text: String
}

class ProblemStatementCellViewModel: ObservableObject {

    @Published var problemStatementParts: [any ProblemStatementPart] = []

    func convertProblemStatement(problemStatement: String) {
        var index = problemStatement.startIndex
        // as long as problemstatemnt is not done
        while index < problemStatement.endIndex {
            var substring: String

            guard let rangeStart = problemStatement.range(of: "@startuml", range: index..<problemStatement.endIndex), let rangeEnd = problemStatement.range(of: "@enduml", range: index..<problemStatement.endIndex) else {
                substring = String(problemStatement[index...])
                substring = deleteTestCases(substring)
                problemStatementParts.append(ProblemStatementMD(text: substring))
                return
            }

            // Append markdown
            substring = String(problemStatement[index..<rangeStart.lowerBound])
            substring = deleteTestCases(substring)
            problemStatementParts.append(ProblemStatementMD(text: substring))

            // Append plantuml
            substring = String(problemStatement[rangeStart.lowerBound...rangeEnd.upperBound])
            substring = replaceTestsColor(substring)
            problemStatementParts.append(ProblemStatementPlantUML(text: substring))

            index = problemStatement.index(rangeEnd.upperBound, offsetBy: 1)
        }
    }

    func deleteTestCases(_ problemStatement: String) -> String {
        return problemStatement
            .replacingOccurrences(of: "[task][", with: "") // to remove symbol
            .replacingOccurrences(of: "](.*())", with: "", options: .regularExpression) // to remove tests
    }

    func replaceTestsColor(_ problemStatement: String) -> String {
        return problemStatement
            .replacingOccurrences(of: "testsColor\\([A-z]+\\)", with: "red", options: .regularExpression) // replace test color by red (or green)
            // .replacingOccurrences(of: "testsColor(testAttributes[.*])", with: "", options: .regularExpression)
            // .replacingOccurrences(of: "testsColor(testMethods[.*])", with: "", options: .regularExpression)
            // .replacingOccurrences(of: "testsColor(testClass[.*])", with: "", options: .regularExpression)
    }
}
