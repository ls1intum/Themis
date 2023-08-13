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
                if courseVM.showEmptyMessage {
                    emptyInfo
                } else {
                    ScrollView(.vertical) {
                        VStack(spacing: 25) {
                            ExerciseGroups(courseVM: courseVM, type: .inAssessment)
                            ExerciseGroups(courseVM: courseVM, type: .viewOnly)
                            Spacer()
                        }
                        .padding(20)
                    }
                    .environmentObject(courseVM)
                    .refreshable {
                        courseVM.fetchAllCourses()
                        courseVM.fetchShownCourseAndSetExercises()
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
                                    .padding(.leading, 40)
                            }
                        }
                    }
                    .onChange(of: courseVM.shownCourseID, perform: { _ in courseVM.fetchShownCourseAndSetExercises() })
                    .isHidden(courseVM.showEmptyMessage)
                    .padding(-10) // compensates for Picker's default padding
                }
            }
        }
        .task {
            courseVM.fetchAllCourses()
            courseVM.fetchShownCourseAndSetExercises()
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
    }
}
