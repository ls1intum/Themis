//
//  CourseView.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

struct CourseView: View {
    var authenticationVM: AuthenticationViewModel
    @StateObject var courseVM = CourseViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if courseVM.loading {
                    ProgressView()
                } else {
                    ExercisesListView(
                        exercises: courseVM.shownCourse?.exercises ?? []
                    )
                    .refreshable {
                        await courseVM.fetchAllCourses()
                    }
                }
            }
            .navigationTitle(navTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { logoutButton }
                ToolbarItem(placement: .primaryAction) {
                    Picker("", selection: $courseVM.shownCourseID) {
                        ForEach(courseVM.pickerCourseIDs, id: \.self) { courseID in
                            if courseID == nil {
                                Text("No course")
                            } else {
                                Text(courseVM.courseForID(id: courseID!)?.title ?? "Invalid")
                            }
                        }
                    }
                }
            }
        }
        .task {
            await courseVM.fetchAllCourses()
        }
//        .errorAlert(error: $courseVM.error)
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
        if courseVM.loading {
            return ""
        }
        guard let shownCourse = courseVM.shownCourse else {
            return "No course"
        }
        return shownCourse.title
    }
}
