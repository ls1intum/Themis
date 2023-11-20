//
//  ExamSectionDetailView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 07.02.23.
//

import SwiftUI
import SharedModels

struct ExamSectionDetailView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @ObservedObject var examDetailVM: ExamDetailViewModel
    
    var body: some View {
        Group {
            if examDetailVM.showNoExercisesInfo {
                noExercisesInfoView
            } else {
                Form {
                    Section("Exercises") {
                        ForEach(examDetailVM.exercises.mock(if: examDetailVM.isLoading)) { exercise in
                            exerciseNavigationLink(for: exercise)
                        }
                    }
                }
            }
        }
        .task {
            examDetailVM.fetchExam()
        }
        .navigationTitle(examDetailVM.examTitle)
    }
    
    @ViewBuilder
    private func exerciseNavigationLink(for exercise: Exercise) -> some View {
        NavigationLink {
            ExerciseView(exercise: exercise, exam: examDetailVM.exam)
                .environmentObject(courseVM)
        } label: {
            HStack {
                exercise.image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .smallImage)
                
                Text(exercise.baseExercise.title ?? "")
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .showsSkeleton(if: examDetailVM.isLoading)
        }
        .disabled(exercise.isDisabled)
    }
    
    @ViewBuilder
    private var noExercisesInfoView: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "xmark")
                    .font(.system(size: 30, weight: .medium))
                    .frame(alignment: .trailing)
                
                Image(systemName: "list.bullet.rectangle.fill")
                    .font(.system(size: 60))
                    .padding([.top, .trailing], 25)
            }
            .padding(.bottom)
            
            Text("There are no exercises in this exam")
                .textCase(.uppercase)
                .font(.system(size: 17, weight: .medium))
        }
        .foregroundColor(.secondary)
    }
}


struct ExamSectionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExamSectionDetailView(examDetailVM: ExamDetailViewModel(courseId: -1, examId: -1))
            .environmentObject(CourseViewModel())
    }
}
