//
//  ExerciseViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    var exercise: Exercise
    @Published var exerciseStats: ExerciseForAssessment?

    init(exercise: Exercise? = nil) {
        if let exercise {
            self.exercise = exercise
        } else {
            self.exercise = Exercise()
        }
    }

    @MainActor
    func fetchExerciseStats() async {
        do {
            self.exerciseStats = try await ArtemisAPI.getExerciseStats(exerciseId: exercise.id)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    var reviewStudents: String {
        let totalNumberOfStudents = exerciseStats?.numberOfSubmissions?.inTime ?? -1
        let totalNumberOfAssessments = exerciseStats?.totalNumberOfAssessments?.inTime ?? -1
        let percentage = Double(totalNumberOfAssessments) / Double(totalNumberOfStudents)
        let percentageString = String(format: "%.2f", percentage)
        return "\(totalNumberOfAssessments) / \(totalNumberOfStudents) (\(percentageString))"
    }
}
