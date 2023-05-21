//
//  ExamListItem.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 21.05.23.
//

import SwiftUI
import SharedModels

struct ExamListItem: View {
    let exam: Exam
    let dateProperties: [ExamDateProperty]

    var body: some View {
        HStack {
            Text(exam.title ?? "Untitled Exam")
                .font(.title2)
                .fontWeight(.medium)
            
            Spacer()
            
            DateTimelineView(dates: dateProperties.map { dateProp in
                (name: dateProp.name, date: exam[keyPath: dateProp.dateKeyPath])
            })
        }
        .padding(.horizontal, 10)
        .tint(.primary)
    }
}
