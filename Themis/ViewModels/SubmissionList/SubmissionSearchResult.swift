//
//  SubmissionSearchResult.swift
//  Themis
//
//  Created by Paul Schwind on 12.12.22.
//

import Foundation

struct SubmissionSearchResult {
    let forText: String
    let submission: Submission

    // https://stackoverflow.com/a/44102415/4306257
    private static func levDis(_ word1: String, _ word2: String) -> Int {
        let empty = [Int](repeating: 0, count: word2.count)
        var last = [Int](0...word2.count)

        for (index, char1) in word1.enumerated() {
            var cur = [index + 1] + empty
            for (index2, char2) in word2.enumerated() {
                cur[index2 + 1] = char1 == char2 ? last[index2] : min(last[index2], last[index2 + 1], cur[index2]) + 1
            }
            last = cur
        }
        return last.last ?? Int.max
    }

    private static func levDisCaseInsensitiveTrimmed(_ word1: String, _ word2: String) -> Int {
        levDis(
            word1.lowercased().trimmingCharacters(in: .whitespaces),
            word2.lowercased().trimmingCharacters(in: .whitespaces)
        )
    }

    private static func scoreCalculation(reference: String, forText: String) -> Double {
        // score is case insentitive Levensthein distance relative to forText length
        // and also the reference length so that they are relatively stable
        return Double(levDisCaseInsensitiveTrimmed(reference, forText)) / Double(forText.count) / Double(reference.count)
    }

    private var student: Student {
        submission.participation.student
    }

    private var nameScore: Double {
        Self.scoreCalculation(reference: forText, forText: student.name)
    }
    private var firstNameScore: Double {
        Self.scoreCalculation(reference: forText, forText: student.firstName)
    }
    private var lastNameScore: Double {
        guard let lastName = student.lastName else {
            return Double(Int.max)
        }
        return Self.scoreCalculation(reference: forText, forText: lastName)
    }
    private var loginScore: Double {
        Self.scoreCalculation(reference: forText, forText: student.login)
    }

    // search result with lower score is better
    var score: Double {
        min(nameScore, firstNameScore, lastNameScore, loginScore)
    }
}
