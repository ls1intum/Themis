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
            List {
                ForEach(courseListVM.courses, id: \.id) { course in
                    NavigationLink {
                        ExercisesListView(
                            title: course.title,
                            exercises: course.exercises
                        )
                    } label: {
                        HStack {
                            Text(course.title ?? "")
                            Spacer()
                            Text(course.shortName ?? "")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { logoutButton }
            }
        }.task {
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
}
