//
//  ExerciseView.swift
//  Themis
//
//  Created by Tom Rudnick on 28.11.22.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject var exerciseVM = ExerciseViewModel()
    @StateObject var avm = AssessmentViewModel(readOnly: false)
    @StateObject var cvm = CodeEditorViewModel()

    let exercise: Exercise

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
                            await avm.initRandomSubmission(exerciseId: exercise.id)
                        }
                    } label: {
                        Text("Start new Assessment")
                            .foregroundColor(.green)
                    }
                    Section("Submission") {
                        SubmissionListView(exerciseId: exercise.id, exerciseTitle: exercise.title ?? "")
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $avm.showSubmission) {
            AssessmentView(
                vm: avm,
                cvm: cvm,
                exerciseId: exercise.id,
                exerciseTitle: exercise.title ?? ""
            )
        }
        .navigationTitle(exercise.title ?? "")
        .onAppear {
            self.exerciseVM.exercise = exercise
            Task {
                await exerciseVM.fetchExerciseStats()
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
