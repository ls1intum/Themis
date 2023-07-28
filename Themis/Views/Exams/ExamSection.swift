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

struct ExamSection: View {
    @EnvironmentObject var courseVM: CourseViewModel
    
    var exams: [Exam]
    var courseID: Int
    
    private let startDate = ExamDateProperty(name: "Exam", dateKeyPath: \.startDate)
    private let assessmentStartDate = ExamDateProperty(name: "Assessment", dateKeyPath: \.endDate)
    private let assessmentDueDate = ExamDateProperty(name: "Review", dateKeyPath: \.publishResultsDate)
    
    var body: some View {
        Group {
            if exams.isEmpty {
                EmptyView()
            } else {
                Text("Exams")
                    .customSectionTitle()
                
                VStack {
                    ForEach(exams, id: \.id) { exam in
                        NavigationLink {
                            ExamSectionDetailView(examID: exam.id, examTitle: exam.title ?? "Untitled Exam")
                                .environmentObject(courseVM)
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
                            .isHidden(exam.id == exams.last?.id, fake: true)
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground).cornerRadius(10))
            }
        }
    }
}
