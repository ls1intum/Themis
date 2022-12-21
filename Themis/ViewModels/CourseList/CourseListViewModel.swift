//
//  CourseListViewModel.swift
//  Themis
//
//  Created by Tom Rudnick on 12.11.22.
//

import SwiftUI

class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []

    @MainActor
    func fetchAllCourses() async {
        do {
            self.courses = try await ArtemisAPI.getAllCourses()
        } catch let error {
            print(error)
        }
    }
}
