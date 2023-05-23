//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI
import UIKit
import SharedModels
import DesignLibrary

struct ExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var assessmentVM = AssessmentViewModel(readOnly: false)
    @StateObject var submissionListVM = SubmissionListViewModel()
    
    let exercise: Exercise
    /// Only set if the exercise is a part of an exam
    var exam: Exam?
    
    var body: some View {
        VStack {
            DataStateView(data: $exerciseVM.exerciseStats,
                          retryHandler: { await exerciseVM.fetchExerciseStats(exerciseId: exercise.id) }) { _ in
                DataStateView(data: $exerciseVM.exerciseStatsForAssessment,
                              retryHandler: { await exerciseVM.fetchExerciseStatsForDashboard(exerciseId: exercise.id) }) { _ in
                    Form {
                        if !submissionListVM.openSubmissions.isEmpty {
                            openSubmissionsSection
                        }
                        
                        if !submissionListVM.submittedSubmissions.isEmpty {
                            finishedSubmissionsSection
                        }
                        
                        statisticsSection
                    }
                    .refreshable { await fetchExerciseData() }
                }
            }
        }
        .navigationDestination(isPresented: $assessmentVM.showSubmission) {
            AssessmentView(
                assessmentVM: assessmentVM,
                assessmentResult: assessmentVM.assessmentResult,
                exercise: exercise
            )
        }
        .navigationTitle(exercise.baseExercise.title ?? "")
        .task { await fetchExerciseData() }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SubmissionSearchView(exercise: exercise)) {
                    searchButton
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                startNewAssessmentButton.disabled(!exerciseVM.isAssessmentPossible)
            }
        }
        .errorAlert(error: $assessmentVM.error)
        .errorAlert(error: $exerciseVM.error, onDismiss: { self.presentationMode.wrappedValue.dismiss() })
    }
    
    private var openSubmissionsSection: some View {
        Section("Open submissions") {
            SubmissionListView(
                assessmentVM: assessmentVM,
                submissionListVM: submissionListVM,
                exercise: exercise,
                submissionStatus: .open
            )
        }.disabled(!exerciseVM.isAssessmentPossible)
    }
    
    private var finishedSubmissionsSection: some View {
        Section("Finished submissions") {
            SubmissionListView(
                assessmentVM: assessmentVM,
                submissionListVM: submissionListVM,
                exercise: exercise,
                submissionStatus: .submitted
            )
        }.disabled(!exerciseVM.isAssessmentPossible)
    }
    
    private var statisticsSection: some View {
        Section("Statistics") {
            HStack(alignment: .center) {
                Spacer()
                CircularProgressView(progress: exerciseVM.participationRate, description: .participationRate)
                CircularProgressView(progress: exerciseVM.assessed, description: .assessed)
                CircularProgressView(progress: exerciseVM.averageScore, description: .averageScore)
                Spacer()
            }
        }
    }
    
    private var searchButton: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .foregroundColor(Color(.label))
                .frame(width: 20, height: 20)
            Text("Search for submission")
                .foregroundColor(Color(.systemGray))
        }
        .padding()
        .background(Material.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var startNewAssessmentButton: some View {
        Button {
            Task {
                await assessmentVM.initRandomSubmission(for: exercise)
            }
        } label: {
            Text("Start Assessment")
                .foregroundColor(.white)
        }
        .buttonStyle(ThemisButtonStyle(color: .themisGreen, iconImageName: "startAssessmentIcon"))
    }
    
    private func fetchExerciseData() async {
        exerciseVM.exam = exam
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await exerciseVM.fetchExercise(exerciseId: exercise.id) }
            group.addTask { await exerciseVM.fetchExerciseStats(exerciseId: exercise.id) }
            group.addTask { await exerciseVM.fetchExerciseStatsForDashboard(exerciseId: exercise.id) }
            group.addTask { await submissionListVM.fetchTutorSubmissions(for: exercise) }
        }
    }
}
