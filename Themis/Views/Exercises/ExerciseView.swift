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
            Form {
                openSubmissionsSection
                
                finishedSubmissionsSection
                
                statisticsSection
                
                problemStatementSection
            }
            .refreshable { await fetchExerciseData() }
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
    
    @ViewBuilder
    private var openSubmissionsSection: some View {
        if submissionListVM.isLoading || !submissionListVM.openSubmissions.isEmpty {
            Section("Open submissions") {
                SubmissionListView(
                    submissionListVM: submissionListVM,
                    exercise: exercise,
                    submissionStatus: .open
                )
            }.disabled(!exerciseVM.isAssessmentPossible)
        }
    }
    
    @ViewBuilder
    private var finishedSubmissionsSection: some View {
        if submissionListVM.isLoading || !submissionListVM.submittedSubmissions.isEmpty {
            Section("Finished submissions") {
                SubmissionListView(
                    submissionListVM: submissionListVM,
                    exercise: exercise,
                    submissionStatus: .submitted
                )
            }.disabled(!exerciseVM.isAssessmentPossible)
        }
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
            .showsSkeleton(if: exerciseVM.isLoading)
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
            group.addTask { await exerciseVM.fetchAllExerciseData(exerciseId: exercise.id) }
            group.addTask { await submissionListVM.fetchTutorSubmissions(for: exercise) }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(exercise: Exercise.mockText)
            .environmentObject(CourseViewModel())
    }
}
