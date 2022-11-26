//
//  SubmissionListViewModel.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import Foundation

class SubmissionListViewModel: ObservableObject {
    @Published var submissions: [Submission] = []

    @MainActor
    func fetchTutorSubmissions(exerciseId: Int) async {
        do {
            self.submissions = try await ArtemisAPI.getTutorSubmissions(exerciseId: exerciseId)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
