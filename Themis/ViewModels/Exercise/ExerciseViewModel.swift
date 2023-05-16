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

    @MainActor
    func fetchExercise(exerciseId: Int) async {
        exercise = await ExerciseServiceFactory.shared.getExerciseForAssessment(exerciseId: exerciseId)
        
        if case .failure(let error) = exercise {
            self.error = error
            log.error(String(describing: error))
        }
    }

    @MainActor
    func fetchExerciseStats(exerciseId: Int) async {
        self.exerciseStatsForAssessment = await ExerciseServiceFactory.shared.getExerciseStatsForAssessmentDashboard(exerciseId: exerciseId)
        
        if case .failure(let error) = exerciseStatsForAssessment {
            self.error = error
            log.error(String(describing: error))
        }
    }
    
    @MainActor
    func fetchExerciseStatsForDashboard(exerciseId: Int) async {
        exerciseStats = await ExerciseServiceFactory.shared.getExerciseStatsForDashboard(exerciseId: exerciseId)
        
        if case .failure(let error) = exerciseStats {
            self.error = error
            log.error(String(describing: error))
        }
    }
    var reviewStudents: String {
        let totalNumberOfStudents = exerciseStatsForAssessment.value?.numberOfSubmissions?.inTime ?? -1
        let totalNumberOfAssessments = exerciseStatsForAssessment.value?.totalNumberOfAssessments?.inTime ?? -1
        let percentage = Double(totalNumberOfAssessments) / Double(totalNumberOfStudents)
        let percentageString = String(format: "%.2f", percentage)
        return "\(totalNumberOfAssessments) / \(totalNumberOfStudents) (\(percentageString))"
    }
    
    var participationRate: Double {
        let numOfParticipations = Double(exerciseStats.value?.numberOfParticipations ?? 0)
        let numOfStudents = Double(exerciseStats.value?.numberOfStudentsOrTeamsInCourse ?? 0)
        return Double(numOfParticipations / numOfStudents)
    }
    
    var averageScore: Double {
        let avgScore = Double(exerciseStats.value?.averageScoreOfExercise ?? 0)
        let maxPoints = Double(exerciseStats.value?.maxPointsOfExercise ?? 0)
        return Double(avgScore / maxPoints)
    }
    
    var assessed: Double {
        let numOfAssessments = Double(exerciseStatsForAssessment.value?.totalNumberOfAssessments?.inTime ?? 0)
        let numOfStudents = Double(exerciseStatsForAssessment.value?.numberOfSubmissions?.inTime ?? 0)
        return Double(CGFloat(numOfAssessments / numOfStudents))
    }
    
    var isAssessmentPossible: Bool {
        (exercise.value?.isCurrentlyInAssessment ?? false)
        || exam?.isOver ?? false
    }
}
