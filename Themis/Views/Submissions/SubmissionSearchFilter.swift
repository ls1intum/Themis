//
//  SubmissionSearchFilter.swift
//  Themis
//
//  Created by Paul Schwind on 30.11.22.
//

import Foundation

struct SearchVisibility {
    let submission: Submission
    let shown: Bool // can be seen in search results at all
    var priority: Int = 0 // determines order
}

/// This represents a filter which determines search visibility of a number of submissions.
class SubmissionSearchFilter: ObservableObject {
    private static let INCLUDED_IN_NAME_PRIO = 10
    private static let ID_START_PRIO = 5

    @Published
    public var searchTerm: String = ""

    private func determineVisibility(_ submission: Submission) -> SearchVisibility {
        if searchTerm.isEmpty {
            return SearchVisibility(submission: submission, shown: true)
        }
        if submission.participation.student.name.lowercased().contains(searchTerm.lowercased()) {
            return SearchVisibility(submission: submission, shown: true, priority: Self.INCLUDED_IN_NAME_PRIO)
        }
        if submission.id.description.starts(with: searchTerm) {
            return SearchVisibility(submission: submission, shown: true, priority: Self.ID_START_PRIO)
        }
        return SearchVisibility(submission: submission, shown: false)
    }

    public func determineResultsInOrder(submissions: [Submission]) -> [Submission] {
        submissions
            .map { submission in determineVisibility(submission) }
            .filter(\.shown)
            .sorted { a, b in a.priority > b.priority }
            .map(\.submission)
    }
}
