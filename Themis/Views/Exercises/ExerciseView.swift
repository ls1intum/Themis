//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI
import UIKit

struct ExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var assessmentVM = AssessmentViewModel(readOnly: false)
    @StateObject var submissionListVM = SubmissionListViewModel()
    let exercise: Exercise
    
    
    var body: some View {
        VStack {
            if let exercise = exerciseVM.exercise, exerciseVM.exerciseStats != nil, exerciseVM.exerciseStatsForDashboard != nil {
                Form {
                    if !submissionListVM.openSubmissions.isEmpty {
                        Section("Open submissions") {
                            SubmissionListView(
                                submissionListVM: submissionListVM,
                                exercise: exercise,
                                submissionStatus: .open
                            )
                        }.disabled(!submissionDueDateOver)
                    }
                    if !submissionListVM.submittedSubmissions.isEmpty {
                        Section("Finished submissions") {
                            SubmissionListView(
                                submissionListVM: submissionListVM,
                                exercise: exercise,
                                submissionStatus: .submitted
                            )
                        }.disabled(!submissionDueDateOver)
                    }
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
                .refreshable { await fetchExerciseData() }
            } else {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $assessmentVM.showSubmission) {
            AssessmentView(
                vm: assessmentVM,
                ar: assessmentVM.assessmentResult,
                exercise: exercise
            )
        }
        .navigationTitle(exercise.title ?? "")
        .task { await fetchExerciseData() }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SubmissionSearchView(exercise: exercise)) {
                    searchButton
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                startNewAssessmentButton.disabled(!submissionDueDateOver)
            }
        }
        .errorAlert(error: $assessmentVM.error)
        .errorAlert(error: $submissionListVM.error)
        .errorAlert(error: $exerciseVM.error, onDismiss: { self.presentationMode.wrappedValue.dismiss() })
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
                await assessmentVM.initRandomSubmission(exerciseId: exercise.id)
            }
        } label: {
            Text("Start Assessment")
                .foregroundColor(.white)
        }
        .buttonStyle(NavigationBarButton())
    }
    private var submissionDueDateOver: Bool {
        if let dueDate = exercise.dueDate, dueDate <= ArtemisDateHelpers.stringifyDate(Date.now)! {
            return true
        }
        return false
    }
    
    private func fetchExerciseData() async {
        exerciseVM.exercise = exercise
        await exerciseVM.fetchExercise(exerciseId: exercise.id)
        await exerciseVM.fetchExerciseStats(exerciseId: exercise.id)
        await exerciseVM.fetchExerciseStatsForDashboard(exerciseId: exercise.id)
        await submissionListVM.fetchTutorSubmissions(exerciseId: exercise.id)
    }
}
