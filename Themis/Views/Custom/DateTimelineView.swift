//
//  TimelineView.swift
//  Themis
//
//  Created by Katjana Kosic on 02.02.23.
//

import SwiftUI

struct DateTimelineView: View {
    let dates: [(name: String, date: Date?)]
    @State private var selectedDate: (String, Date?) = ("", nil)

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 450, height: 5)
                .foregroundColor(Color.blue)
                .cornerRadius(5)
            HStack {
                ForEach(dates, id: \.name) { nameAndDateTuple in
                    VStack {
                        Text(nameAndDateTuple.name).bold()
                        Image(systemName: "calendar")
                            .background(Color(.secondarySystemGroupedBackground))
                            .font(.title3)
                            .padding(1)
                        if let dateString = ArtemisDateHelpers.getRemainingOrOverdueTime(for: nameAndDateTuple.date) {
                            Text(dateString)
                        } else {
                            Text("Not available yet")
                        }
                    }
                    .frame(maxWidth: 150)
                    .padding(2)
                }
            }
        }
    }
}
