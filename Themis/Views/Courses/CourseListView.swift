//
//  CourseListView.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

struct CourseListView: View {
    var authenticationVM: AuthenticationViewModel
    @StateObject var courseListVM = CourseListViewModel()

    var body: some View {
        NavigationStack {
            ExercisesListView(
                exercises: courseListVM.shownCourse?.exercises ?? []
            )
            .navigationTitle(navTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { logoutButton }
                ToolbarItem(placement: .primaryAction) {
                    Picker("", selection: $courseListVM.shownCourseID) {
                        ForEach(courseListVM.pickerCourseIDs, id: \.self) { courseID in
                            if courseID == nil {
                                Text("No course")
                            } else {
                                Text(courseListVM.courseForID(id: courseID!)?.title ?? "Invalid")
                            }
                        }
                    }
                }
            }
        }
        .task {
            await courseListVM.fetchAllCourses()
        }
    }

    var logoutButton: some View {
        Button {
            Task {
                await authenticationVM.logout()
            }
        } label: {
            Text("Logout")
        }
    }
    
    var navTitle: String {
        guard let shownCourse = courseListVM.shownCourse else {
            return "No course"
        }
        return "\(shownCourse.title) Exercises"
    }
}
