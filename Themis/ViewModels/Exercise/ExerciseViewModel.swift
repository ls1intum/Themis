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
    @Published var isLoading = false
    
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
              let numberOfStudentsOrTeamsInCourse,
              numberOfParticipations * numberOfStudentsOrTeamsInCourse != 0
        else {
            return 0.0
        }
        return Double(numberOfParticipations) / Double(numberOfStudentsOrTeamsInCourse)
    }
    
    var averageScoreOfExercise: Double? {
        exerciseStats.value?.averageScoreOfExercise
    }
    
    var maxPointsOfExercise: Double? {
        exerciseStats.value?.maxPointsOfExercise
    }
    
    var averageScore: Double {
        guard let averageScoreOfExercise,
              let maxPointsOfExercise,
              averageScoreOfExercise * maxPointsOfExercise != 0
        else {
            return 0.0
        }
        return averageScoreOfExercise / maxPointsOfExercise
    }
    
    var numberOfAssessmentsInTime: Int? {
        exerciseStatsForAssessment.value?.totalNumberOfAssessments?.inTime
    }
    
    var numberOfSubmissionsInTime: Int? {
        exerciseStatsForAssessment.value?.numberOfSubmissions?.inTime
    }
    
    var assessed: Double {
        guard let numberOfAssessmentsInTime,
              let numberOfSubmissionsInTime,
              numberOfAssessmentsInTime * numberOfSubmissionsInTime != 0
        else {
            return 0.0
        }
        return Double(numberOfAssessmentsInTime) / Double(numberOfSubmissionsInTime)
    }
    
    var isAssessmentPossible: Bool {
        (exercise.value?.isCurrentlyInAssessment ?? false)
        || ((exam?.isOver ?? false) && !(exam?.isAssessmentDue ?? true))
    }
    
    private var isLoadedOnce = false
    
    @MainActor
    func fetchAllExerciseData(exerciseId: Int) async {
        isLoading = isLoadedOnce ? isLoading : true
        defer {
            isLoading = false
            isLoadedOnce = true
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [weak self] in await self?.fetchExercise(exerciseId: exerciseId) }
            group.addTask { [weak self] in await self?.fetchExerciseStats(exerciseId: exerciseId) }
            group.addTask { [weak self] in await self?.fetchExerciseStatsForDashboard(exerciseId: exerciseId) }
        }
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
