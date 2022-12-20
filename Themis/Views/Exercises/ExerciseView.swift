//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var vm = AssessmentViewModel(readOnly: false)
    @StateObject var cvm = CodeEditorViewModel()
    @StateObject var umlVM = UMLViewModel()

    let exercise: Exercise

    var body: some View {
        VStack {
            if let exercise = exerciseVM.exercise, exerciseVM.exerciseStats != nil {
                Form {
                    HStack {
                        Text("Assessed:")
                        Spacer()
                        Text(exerciseVM.reviewStudents)
                    }
                    Button {
                        Task {
                            await vm.initRandomSubmission(exerciseId: exercise.id)
                        }
                    } label: {
                        Text("Start new Assessment")
                            .foregroundColor(.green)
                    }
                    Section("Submission") {
                        SubmissionListView(
                            exerciseId: exercise.id,
                            exerciseTitle: exercise.title ?? "",
                            templateParticipationId: exercise.templateParticipation?.id ?? -1
                        )
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $vm.showSubmission) {
            AssessmentView(
                exerciseId: exercise.id,
                exerciseTitle: exercise.title ?? "",
                templateParticipationId: exercise.templateParticipation?.id ?? -1
            )
                .environmentObject(vm)
                .environmentObject(cvm)
                .environmentObject(umlVM)
        }
        .navigationTitle(exercise.title ?? "")
        .onAppear {
            exerciseVM.exercise = exercise
            Task {
                await exerciseVM.fetchExercise(exerciseId: exercise.id)
                await exerciseVM.fetchExerciseStats(exerciseId: exercise.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SubmissionSearchView(exercise: exercise)) {
                    searchButton
                }
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
}
