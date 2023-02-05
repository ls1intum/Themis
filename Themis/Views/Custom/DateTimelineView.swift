//
//  TimelineView.swift
//  Themis
//
//  Created by Katjana Kosic on 02.02.23.
//

import SwiftUI

struct DateTimelineView: View {
    let dates: [(name: String, date: String?)]
    @State private var showingAlert = false
    @State private var selectedDate: (String, String?) = ("", nil)

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 650, height: 6)
                .foregroundColor(Color.blue)
            HStack {
                ForEach(dates, id: \.name) { date in
                    VStack {
                        Text(date.name)
                        Image(systemName: "calendar")
                            .background(Color.white)
                            .font(.system(size: 30))
                            .padding(1)
                            .onLongPressGesture {
                                selectedDate = (date.name, date.date)
                                showingAlert = true
                            }
                        if let dateString = ArtemisDateHelpers.getRemainingOrOverdueTime(for: date.date) {
                            Text(dateString)
                        } else {
                            Text("Not available yet")
                        }
                    }
                    .frame(maxWidth: 150)
                    .padding()
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Due date for \(selectedDate.0)"),
                  message: selectedDate.1.map { date in Text(ArtemisDateHelpers.getReadableDateString(date) ?? "Not available yet") },
                  dismissButton: nil)
        }
    }
}