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
    
    var startAssessmentButtonText: String {
        currentCorrectionRound == .first ? "Start Assessment" : "Start Assessment (Round 2)"
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
    
    var numberOfSecondRoundAssessmentsInTime: Int? {
        exerciseStatsForAssessment.value?.numberOfAssessmentsOfCorrectionRounds?[safe: 1]?.inTime
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
    
    var assessedSecondRound: Double {
        guard let numberOfSecondRoundAssessmentsInTime,
              let numberOfSubmissionsInTime,
              numberOfSecondRoundAssessmentsInTime * numberOfSubmissionsInTime != 0
        else {
            return 0.0
        }
        return Double(numberOfSecondRoundAssessmentsInTime) / Double(numberOfSubmissionsInTime)
    }
    
    var isAssessmentPossible: Bool {
        (exercise.value?.isCurrentlyInAssessment ?? false)
        || ((exam?.isOver ?? false) && !(exam?.isAssessmentDue ?? true))
    }
    
    /// Is true if this VM contains an exam supporting second correction round
    var hasExamSupportingSecondCorrectionRound: Bool {
        exam?.numberOfCorrectionRoundsInExam == 2
    }
    
    /// Is true if this VM contains an exam and an exercise supporting second correction round.
    /// This is needed because not all exam exercises support the second round
    var isSecondCorrectionRoundEnabled: Bool {
        hasExamSupportingSecondCorrectionRound && exercise.value?.baseExercise.secondCorrectionEnabled == true
    }
    
    var currentCorrectionRound: CorrectionRound {
        (isSecondCorrectionRoundEnabled && assessed == 1.0) ? .second : .first
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
        if case .failure(let error) = data,
           let errorMessage = error.message,
           !errorMessage.contains("cancel") { // cancellation occurs when the user leaves the view before the response arrives
            self.error = error
            log.error(String(describing: error))
        }
    }
}
