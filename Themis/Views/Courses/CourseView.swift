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
                if courseVM.loading || courseVM.shownCourse == nil {
                    ProgressView()
                } else {
                    Form {
                        ExerciseSections(
                            exercises: courseVM.shownCourse?.exercises ?? []
                        )
                        
                        Section("Exams") {
                            ExamListView(exams: courseVM.shownCourse?.exams ?? [], courseID: courseVM.shownCourse!.id)
                        }
                    }
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


struct ExamListView: View {
    var exams: [Exam]
    var courseID: Int
    
    @State var selectedExam: Exam?
    @State var showExam = false
    
    var body: some View {
        Group {
            ForEach(exams, id: \.id) { exam in
                NavigationLink {
                    ExamExerciseSectionWrapper(examID: exam.id, courseID: courseID)
                } label: {
                    Text(exam.title)
                }
            }
        }
    }
}


struct ExamExerciseSectionWrapper: View {
    var examID: Int
    var courseID: Int
    
    @State var exercises: [Exercise] = []
    
    var body: some View {
        Form {
            ExerciseSections(
                exercises: exercises
            )
        }.task {
            let exam = try? await ArtemisAPI.getExamForAssessment(courseID: courseID, examID: examID)
            guard let exam else { return }
            self.exercises = exam.exercises
        }
    }
}

