//
//  ExercisesListView.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

struct ExercisesListView: View {
    @ObservedObject var courseListVM: CourseListViewModel
    var courseID: Int

    var body: some View {
        courseListVM.courseForID(id: courseID).exercises.flatMap { exerciseList in
            List {
                ForEach(exerciseList, id: \.id) { exercise in
                    NavigationLink {
                        ExerciseView(exercise: exercise)
                    } label: {
                        HStack {
                            Text(exercise.title ?? "")
                            Spacer()
                            Text("Due Date:")
                            Text(exercise.getReadableDateString(exercise.dueDate))
                        }
                    }
                }
            }.navigationTitle(title)
        }
    }

    var title: String {
        return "\(courseListVM.courseForID(id: courseID).title ?? "") Exercises"
    }

}
