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
    let colorScheme: ColorScheme
    let text: String
    var url: URL? {
        var url = URL(string: "\(RESTController.shared.baseURL)/api/plantuml/png")
        url?.append(queryItems: [URLQueryItem(name: "plantuml", value: text), URLQueryItem(name: "useDarkTheme", value: String(colorScheme != .light))])
        return url
    }
}

struct ProblemStatementMD: ProblemStatementPart {
    let text: String
}

struct BundledTest: Equatable {
    var testCase: String
    var passed: Bool
}

class ProblemStatementCellViewModel: ObservableObject {

    @Published var problemStatementParts: [any ProblemStatementPart] = []
    @Published var bundledTests: [BundledTest] = []

    func convertProblemStatement(problemStatement: String, feedbacks: [AssessmentFeedback], colorScheme: ColorScheme) {
        problemStatementParts = []
        bundledTests = []
        var index = problemStatement.startIndex

        while index < problemStatement.endIndex {
            var substring: String

            guard let rangeStart = problemStatement.range(of: "@startuml", range: index..<problemStatement.endIndex), let rangeEnd = problemStatement.range(of: "@enduml", range: index..<problemStatement.endIndex) else {
                substring = String(problemStatement[index...])
                substring = replaceProblemStatementTestCases(substring, feedbacks)
                problemStatementParts.append(ProblemStatementMD(text: substring))
                return
            }

            // Append markdown
            substring = String(problemStatement[index..<rangeStart.lowerBound])
            substring = replaceProblemStatementTestCases(substring, feedbacks)
            problemStatementParts.append(ProblemStatementMD(text: substring))

            // Append plantuml
            substring = String(problemStatement[rangeStart.lowerBound...rangeEnd.upperBound])
            substring = replaceUMLTestsColor(substring, feedbacks, colorScheme)
            problemStatementParts.append(ProblemStatementPlantUML(colorScheme: colorScheme, text: substring))

            index = problemStatement.index(rangeEnd.upperBound, offsetBy: 1)
        }
    }

    private func replaceProblemStatementTestCases(_ problemStatement: String, _ feedbacks: [AssessmentFeedback]) -> String {
        var problemStatementText = problemStatement

        for feedback in feedbacks {
            if let feedbackText = feedback.text {
                problemStatementText = problemStatementText
                    .replacingOccurrences(of: "\(feedbackText)", with: feedback.credits == 0.0 ? "0" : "1")
            }
        }

        let lines = problemStatementText.components(separatedBy: "\n")
        problemStatementText = ""

        for var line in lines {
            if line.contains("[task][") && line.contains("0") {
                line = calculateScoreOfPassingTests(line)
                line = line.replacingOccurrences(of: "[task][", with: " ![Test failed](asset:///TestFailedSymbol) **")
                bundledTests.append(BundledTest(testCase: line, passed: false))
            } else if line.contains("[task][") && line.contains("1") {
                line = calculateScoreOfPassingTests(line)
                line = line.replacingOccurrences(of: "[task][", with: " ![Test passed](asset:///TestPassedSymbol) **")
                bundledTests.append(BundledTest(testCase: line, passed: true))
            }

            problemStatementText.append(line + "\n")
        }

        return problemStatementText
    }

    private func calculateScoreOfPassingTests(_ line: String) -> String {
        if let rangeStart = line.range(of: "](", range: line.startIndex..<line.endIndex) {
            let lineBeforeScore = String(line[...rangeStart.lowerBound].dropLast())

            let scoreSubstring = String(line[rangeStart.lowerBound...].dropFirst().dropFirst().dropLast())

            let scoreSubstringArray = scoreSubstring.components(separatedBy: ",").map { Int($0) ?? 0 }

            let lineScore = " (\(scoreSubstringArray.reduce(0, +)) of \(scoreSubstringArray.count) tests passing)** "

            return lineBeforeScore + lineScore
        }

        return line
    }

    private func replaceUMLTestsColor(_ problemStatement: String, _ feedbacks: [AssessmentFeedback], _ colorSchemeVariable: ColorScheme) -> String {
        var plantUML = problemStatement

        for feedback in feedbacks {
            if let feedbackText = feedback.text {
                plantUML = plantUML.replacingOccurrences(
                    of: "testsColor(\(feedbackText))",
                    with: feedback.credits == 0.0 ? "red" : "green")
            }
        }

        return plantUML.replacingOccurrences(
                    of: "testsColor\\([A-z]+\\)",
                    with: colorSchemeVariable == .light ? "black" : "white",
                    options: .regularExpression)
    }
}
