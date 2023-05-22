//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI
import UIKit
import DesignLibrary
import SharedModels
import DesignLibrary

struct ExerciseView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var assessmentVM = AssessmentViewModel(readOnly: false)
    @StateObject var submissionListVM = SubmissionListViewModel()
    
    @State private var problemStatementHeight: CGFloat = 1.0
    @State private var problemStatementRequest: URLRequest
    
    let exercise: Exercise
    /// Only set if the exercise is a part of an exam
    var exam: Exam?
    
    init(exercise: Exercise, courseId: Int, exam: Exam? = nil) {
        self.exercise = exercise
        self.exam = exam
        self._problemStatementRequest = State(wrappedValue: URLRequest(url: URL(string: "/courses/\(courseId)/exercises/\(exercise.id)/problem-statement", relativeTo: RESTController.shared.baseURL)!))
    }
    
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
        .errorAlert(error: $assessmentVM.error)
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
                CircularProgressView(progress: exerciseVM.participationRate, description: .participationRate)
                CircularProgressView(progress: exerciseVM.assessed, description: .assessed)
                CircularProgressView(progress: exerciseVM.averageScore, description: .averageScore)
                Spacer()
            }
        }
    }
    
    private var problemStatementSection: some View {
        Section("Problem Statement") {
            ArtemisWebView(urlRequest: $problemStatementRequest,
                           contentHeight: $problemStatementHeight)
            .disabled(true)
            .frame(height: problemStatementHeight)
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
                await assessmentVM.initRandomSubmission(exerciseId: exercise.id)
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
            group.addTask { await submissionListVM.fetchTutorSubmissions(exerciseId: exercise.id) }
        }
    }
}
