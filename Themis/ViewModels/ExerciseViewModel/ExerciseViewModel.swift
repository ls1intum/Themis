//
//  ExerciseViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    @Published var exercise: Exercise?
    @Published var exerciseStats: ExerciseForAssessment?

    @MainActor
    func fetchExercise(exerciseId: Int) async {
        do {
            self.exercise = try await ArtemisAPI.getExercise(exerciseId: exerciseId)
        } catch {
            print(error)
        }
    }

    @MainActor
    func fetchExerciseStats(exerciseId: Int) async {
        do {
            self.exerciseStats = try await ArtemisAPI.getExerciseStats(exerciseId: exerciseId)
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
