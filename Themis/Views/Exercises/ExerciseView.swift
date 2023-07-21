//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI
import DesignLibrary
import SharedModels
import UserStore

struct ExerciseView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var submissionListVM = SubmissionListViewModel()
    @State var showAssessmentView = false
    
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
                        
                        problemStatementSection
                    }
                    .refreshable { await fetchExerciseData() }
                }
            }
        }
        .navigationDestination(isPresented: $showAssessmentView) {
            AssessmentView(exercise: exercise)
                .environmentObject(courseVM)
        }
        .navigationTitle(exercise.baseExercise.title ?? "")
        .task { await fetchExerciseData() }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SubmissionSearchView(exercise: exercise).environmentObject(courseVM)) {
                    searchButton
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                startNewAssessmentButton.disabled(!exerciseVM.isAssessmentPossible)
            }
        }
        .errorAlert(error: $exerciseVM.error, onDismiss: { self.presentationMode.wrappedValue.dismiss() })
    }
    
    private var openSubmissionsSection: some View {
        Section("Open submissions") {
            SubmissionListView(
                submissionListVM: submissionListVM,
                exercise: exercise,
                submissionStatus: .open
            )
        }.disabled(!exerciseVM.isAssessmentPossible)
    }
    
    private var finishedSubmissionsSection: some View {
        Section("Finished submissions") {
            SubmissionListView(
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
                CircularProgressView(progress: exerciseVM.participationRate,
                                     description: .participationRate,
                                     maxValue: Double(exerciseVM.numberOfStudentsOrTeamsInCourse ?? 0),
                                     currentValue: Double(exerciseVM.numberOfParticipations ?? 0))

                CircularProgressView(progress: exerciseVM.assessed,
                                     description: .assessed,
                                     maxValue: Double(exerciseVM.numberOfSubmissionsInTime ?? 0),
                                     currentValue: Double(exerciseVM.numberOfAssessmentsInTime ?? 0))

                CircularProgressView(progress: exerciseVM.averageScore,
                                     description: .averageScore,
                                     maxValue: exerciseVM.maxPointsOfExercise,
                                     currentValue: exerciseVM.averageScoreOfExercise)
                Spacer()
            }
        }
    }
    
    private var problemStatementSection: some View {
        Section("Problem Statement") {
            ProblemStatementView(courseId: courseVM.shownCourseID, exerciseId: exercise.id)
                .frame(maxHeight: .infinity)
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
            showAssessmentView = true
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
