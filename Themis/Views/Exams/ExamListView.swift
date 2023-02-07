//
//  ExamListView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 07.02.23.
//

import SwiftUI

struct ExamListView: View {
    var exams: [Exam]
    var courseID: Int
    
    var body: some View {
        Group {
            ForEach(exams, id: \.id) { exam in
                NavigationLink {
                    ExamSectionView(examID: exam.id, courseID: courseID)
                } label: {
                    Text(exam.title)
                }
            }
        }
    }
}
