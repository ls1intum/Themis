//
//  SubmissionListViewModel.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import Common
import Foundation
import SharedModels

class SubmissionListViewModel: ObservableObject {
    @Published var submissions: [Submission] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    var submittedSubmissions: [Submission] {
        submissions.filter { $0.baseSubmission.results?.last?.completionDate != nil }
    }
    
    var openSubmissions: [Submission] {
        submissions.filter { $0.baseSubmission.results?.last?.completionDate == nil }
    }
    
    private var isLoadedOnce = false
    
    @MainActor
    func fetchTutorSubmissions(for exercise: Exercise) async {
        isLoading = isLoadedOnce ? isLoading : true
        defer {
            isLoading = false
            isLoadedOnce = true
        }
        
        do {
            let submissionService = SubmissionServiceFactory.service(for: exercise)
            self.submissions = try await submissionService.getTutorSubmissions(exerciseId: exercise.id)
        } catch let error {
            self.error = error
            log.error(String(describing: error))
        }
    }
}

 enum SubmissionStatus {
    case open
    case submitted
 }
