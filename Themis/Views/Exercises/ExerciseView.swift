//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI

struct ExerciseView: View {
    var exercise: Exercise
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var vm = AssessmentViewModel()
    @StateObject var cvm = CodeEditorViewModel()

    var body: some View {
        VStack {
            if exerciseVM.exerciseStats != nil {
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
                        SubmissionListView(exerciseId: exercise.id)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $vm.showSubmission) {
            AssessmentView(exerciseId: exercise.id)
                .environmentObject(vm)
                .environmentObject(cvm)
        }
        .navigationTitle(exercise.title ?? "")
        .onAppear {
            self.exerciseVM.exercise = exercise
            Task {
                await exerciseVM.fetchExerciseStats()
            }
        }
    }
}
