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
                    Form {
                        ExerciseSections(
                            exercises: courseVM.shownCourse?.exercises ?? []
                        )
                        
                        if let courseId = courseVM.shownCourse?.id, !(courseVM.shownCourse?.exams?.isEmpty ?? false) {
                            Section("Exams") {
                                ExamListView(exams: courseVM.shownCourse?.exams ?? [], courseID: courseId)
                            }
                        }
                    }
                    .environmentObject(courseVM)
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
                            if let courseID {
                                Text(courseVM.courseForID(id: courseID)?.title ?? "Invalid")
                            } else {
                                Text("No course")
                            }
                        }
                    }
                }
            }
        }
        .task {
            await courseVM.fetchAllCourses()
        }
        .errorAlert(error: $courseVM.error)
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
        return shownCourse.title ?? "Unnamed course"
    }
}
