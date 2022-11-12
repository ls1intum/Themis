//
//  ExercisesListView.swift
//  feedback2go
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
                    HStack {
                        Text(exercise.title ?? "")
                    }
                }
            }
        }
    }
}

