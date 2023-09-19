//
//  SubmissionSearchViewModel.swift
//  Themis
//
//  Created by Andreas Cselovszky on 04.12.22.
//

import Common
import Foundation
import SharedModels

class SubmissionSearchViewModel: ObservableObject {
    @Published var submissions: [Submission] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let maxPercentDiffFromBestResultToStillShow = 0.15 // based on experimentation

    @MainActor
    func fetchSubmissions(exercise: Exercise) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            self.submissions = try await submissionService.getAllSubmissions(exerciseId: exercise.id)
        } catch {
            self.error = error
            log.error(String(describing: error))
        }
    }

    func filterSubmissions(search: String) -> [Submission] {
        if search.isEmpty {
            return submissions
        }
        
        let searchResults: [SubmissionSearchResult] = submissions
            .map { submission in SubmissionSearchResult(forText: search, submission: submission) }
        let scores = searchResults.map(\.score)
        let bestScore: Double = scores.min() ?? 0.0
        return searchResults
            .sorted { $0.score < $1.score }
            .filter { $0.score <= (1 + maxPercentDiffFromBestResultToStillShow) * bestScore }
            .map(\.submission)
    }
}
