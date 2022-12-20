//
//  SubmissionSearchViewModel.swift
//  Themis
//
//  Created by Andreas Cselovszky on 04.12.22.
//

import Foundation

class SubmissionSearchViewModel: ObservableObject {
    @Published var submissions: [Submission] = []

    @MainActor
    func fetchSubmissions(exerciseId: Int) async {
        do {
            self.submissions = try await ArtemisAPI.getAllSubmissions(exerciseId: exerciseId)
        } catch {
            print(error)
        }
    }

    func filterSubmissions(search: String) -> [Submission] {
        let search = search.lowercased().trimmingCharacters(in: .whitespaces)
        guard !search.isEmpty else {
            return submissions
        }
        return submissions.filter { submission in
            let student = submission.participation.student
            let name = student.name.lowercased().trimmingCharacters(in: .whitespaces)
            let login = student.login.lowercased().trimmingCharacters(in: .whitespaces)
            return name.contains(search) || login.contains(search)
        }
    }
}
