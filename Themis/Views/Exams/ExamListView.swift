//
//  ExamListView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 07.02.23.
//

import SwiftUI
import SharedModels

struct ExamDateProperty: Hashable {
    let name: String
    let dateKeyPath: KeyPath<Exam, String?>
}

struct ExamListView: View {
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
                ForEach(exams, id: \.id) { exam in
                    NavigationLink {
                        ExamSectionView(examID: exam.id, courseID: courseID, examTitle: exam.title)
                    } label: {
                        ExamListItem(exam: exam, dateProperties: [
                            startDate,
                            assessmentStartDate,
                            assessmentDueDate
                        ])
                    }
                }
            }
        }
    }
}

private struct ExamListItem: View {
    let exam: Exam
    let dateProperties: [ExamDateProperty]

    var body: some View {
        HStack {
            Text(exam.title)
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
            DateTimelineView(dates: dateProperties.map { dateProp in
                (name: dateProp.name, date: exam[keyPath: dateProp.dateKeyPath])
            })
        }
        .padding(.trailing)
    }
}
