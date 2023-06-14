//
//  CourseView.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI
import Login
import APIClient
import UserStore

struct CourseView: View {
    @StateObject var courseVM = CourseViewModel()
        
    private var navTitle: String {
        guard let shownCourse = courseVM.shownCourse, !courseVM.loading else {
            return ""
        }
        return shownCourse.title ?? "Unnamed course"
    }

    var body: some View {
        NavigationStack {
            Group {
                if courseVM.loading {
                    ProgressView()
                } else if courseVM.showEmptyMessage {
                    emptyInfo
                } else {
                    Form {
                        ExerciseSections(
                            exercises: courseVM.shownCourse?.exercises ?? []
                        )
                        if courseVM.hasExams {
                            Section("Exams") {
                                ExamListView(exams: courseVM.shownCourse?.exams ?? [])
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
                ToolbarItemGroup(placement: .cancellationAction) {
                    logoutButton
                    userFirstName
                }
                ToolbarItem(placement: .primaryAction) {
                    Picker("", selection: $courseVM.shownCourseID) {
                        ForEach(courseVM.pickerCourseIDs, id: \.self) { courseID in
                            if let courseID {
                                Text(courseVM.courseForID(id: courseID)?.title ?? "Invalid")
                            }
                        }
                    }.isHidden(courseVM.showEmptyMessage)
                }
            }
        }
        .task {
            await courseVM.fetchAllCourses()
        }
        .errorAlert(error: $courseVM.error)
    }

    private var logoutButton: some View {
        Button {
            APIClient().perfomLogout()
        } label: {
            Text("Logout")
        }
    }
    
    private var userFirstName: some View {
        Text(UserSession.shared.user?.name ?? "")
            .foregroundColor(.secondary)
            .font(.callout)
    }
    
    private var emptyInfo: some View {
        VStack {
            Image(systemName: "person.fill.xmark")
                .font(.system(size: 80))
                .padding(.bottom)
            
            Text("You are not assigned to any course as a teaching assistant")
                .textCase(.uppercase)
                .font(.system(size: 17, weight: .medium))
        }
        .foregroundColor(.secondary)
    }
}

struct CourseView_Previews: PreviewProvider {
    static var courseVM = CourseViewModel()
    
    static var previews: some View {
        CourseView(courseVM: courseVM)
            .onAppear {
                courseVM.showEmptyMessage = true
            }
    }
}
