//
//  CourseView.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI
import Login
import APIClient

struct CourseView: View {
    @StateObject var courseVM = CourseViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if courseVM.loading {
                    ProgressView()
                } else {
                    ScrollView {
                        Group {
                            ExerciseGroups(courseVM: courseVM, type: .inAssessment)
                                .padding(.bottom)
                            ExerciseGroups(courseVM: courseVM, type: .viewOnly)
                                .disabled(true) // TODO: remove once view-only mode is fully implemented
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                    }
                    .refreshable {
                        await courseVM.fetchAllCourses()
                        await courseVM.fetchShownCourseAndSetExercises()
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
                    .onChange(of: courseVM.shownCourseID, perform: { _ in Task { await courseVM.fetchShownCourseAndSetExercises() } })
                }
            }
        }
        .task {
            await courseVM.fetchAllCourses()
            await courseVM.fetchShownCourseAndSetExercises()
        }
//        .errorAlert(error: $courseVM.error)
    }

    var logoutButton: some View {
        Button {
            APIClient().perfomLogout()
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
