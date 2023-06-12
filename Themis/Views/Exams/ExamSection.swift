//
//  ExamSection.swift
//  Themis
//
//  Created by Andreas Cselovszky on 07.02.23.
//

import SwiftUI
import SharedModels

struct ExamDateProperty: Hashable {
    let name: String
    let dateKeyPath: KeyPath<Exam, Date?>
}

<<<<<<< HEAD:Themis/Views/Exams/ExamSection.swift
struct ExamSection: View {
=======
struct ExamListView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    
>>>>>>> develop:Themis/Views/Exams/ExamListView.swift
    var exams: [Exam]
    var courseID: Int
    
    private let startDate = ExamDateProperty(name: "Exam", dateKeyPath: \.startDate)
    private let assessmentStartDate = ExamDateProperty(name: "Assessment", dateKeyPath: \.startDate)
    private let assessmentDueDate = ExamDateProperty(name: "Review", dateKeyPath: \.publishResultsDate)
    
    var body: some View {
        Group {
            if exams.isEmpty {
                EmptyView()
            } else {
<<<<<<< HEAD:Themis/Views/Exams/ExamSection.swift
                Text("Exams")
                    .customSectionTitle()
                
                VStack {
                    ForEach(exams, id: \.id) { exam in
                        NavigationLink {
                            ExamSectionDetailView(examID: exam.id, courseID: courseID, examTitle: exam.title ?? "Untitled Exam")
                        } label: {
                            ExamListItem(exam: exam, dateProperties: [
                                startDate,
                                assessmentStartDate,
                                assessmentDueDate
                            ])
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                        }
                        
                        Divider()
                            .padding(.leading, .xl)
=======
                ForEach(exams, id: \.id) { exam in
                    NavigationLink {
                        ExamSectionView(examID: exam.id, courseID: courseID, examTitle: exam.title ?? "Untitled Exam")
                            .environmentObject(courseVM)
                    } label: {
                        ExamListItem(exam: exam, dateProperties: [
                            startDate,
                            assessmentStartDate,
                            assessmentDueDate
                        ])
>>>>>>> develop:Themis/Views/Exams/ExamListView.swift
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground).cornerRadius(10))
            }
        }
    }
}
