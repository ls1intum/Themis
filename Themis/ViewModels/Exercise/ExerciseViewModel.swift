//
//  ExerciseViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import Common
import Foundation
import SharedModels
import SharedServices

class ExerciseViewModel: ObservableObject {
    @Published var exercise: DataState<Exercise> = .loading
    @Published var exam: Exam?
    @Published var exerciseStatsForAssessment: DataState<ExerciseStatsForAssessmentDashboard> = .loading
    @Published var exerciseStats: DataState<ExerciseStatistics> = .loading
    @Published var error: Error?
    
    var reviewStudents: String {
        let totalNumberOfStudents = exerciseStatsForAssessment.value?.numberOfSubmissions?.inTime ?? -1
        let totalNumberOfAssessments = exerciseStatsForAssessment.value?.totalNumberOfAssessments?.inTime ?? -1
        let percentage = Double(totalNumberOfAssessments) / Double(totalNumberOfStudents)
        let percentageString = String(format: "%.2f", percentage)
        return "\(totalNumberOfAssessments) / \(totalNumberOfStudents) (\(percentageString))"
    }
    
    var numberOfParticipations: Int? {
        exerciseStats.value?.numberOfParticipations
    }
    
    var numberOfStudentsOrTeamsInCourse: Int? {
        exerciseStats.value?.numberOfStudentsOrTeamsInCourse
    }
    
    var participationRate: Double {
        guard let numberOfParticipations,
              let numberOfStudentsOrTeamsInCourse else {
            return 0.0
        }
        return Double(numberOfParticipations) / Double(numberOfStudentsOrTeamsInCourse)
    }
    
    var averageScore: Double {
        guard let avgScore = exerciseStats.value?.averageScoreOfExercise,
              let maxPoints = exerciseStats.value?.maxPointsOfExercise else {
            return 0.0
        }
        return avgScore / maxPoints
    }
    
    var numberOfAssessmentsInTime: Int? {
        exerciseStatsForAssessment.value?.totalNumberOfAssessments?.inTime
    }
    
    var numberOfSubmissionsInTime: Int? {
        exerciseStatsForAssessment.value?.numberOfSubmissions?.inTime
    }
    
    var assessed: Double {
        guard let numberOfAssessmentsInTime,
              let numberOfSubmissionsInTime  else {
            return 0.0
        }
        return Double(numberOfAssessmentsInTime) / Double(numberOfSubmissionsInTime)
    }
    
    var isAssessmentPossible: Bool {
        (exercise.value?.isCurrentlyInAssessment ?? false)
        || exam?.isOver ?? false
    }

    @MainActor
    func fetchExercise(exerciseId: Int) async {
        exercise = await ExerciseServiceFactory.shared.getExerciseForAssessment(exerciseId: exerciseId)
        showErrorIfFailedFetching(exercise)
    }

    @MainActor
    func fetchExerciseStats(exerciseId: Int) async {
        exerciseStatsForAssessment = await ExerciseServiceFactory.shared.getExerciseStatsForAssessmentDashboard(exerciseId: exerciseId)
        showErrorIfFailedFetching(exerciseStatsForAssessment)
    }
    
    @MainActor
    func fetchExerciseStatsForDashboard(exerciseId: Int) async {
        exerciseStats = await ExerciseServiceFactory.shared.getExerciseStatsForDashboard(exerciseId: exerciseId)
        showErrorIfFailedFetching(exerciseStats)
    }
    
    private func showErrorIfFailedFetching<T>(_ data: DataState<T>) {
        if case .failure(let error) = data {
            self.error = error
            log.error(String(describing: error))
        }
    }
}
