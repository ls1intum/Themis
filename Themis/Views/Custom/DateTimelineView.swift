//
//  TimelineView.swift
//  Themis
//
//  Created by Katjana Kosic on 02.02.23.
//

import SwiftUI

 struct DateTimelineView: View {
    let dates: [(name: String, date: String?)]
    @State private var isShowingPopover = false
    @State private var selectedDate: (String, String?) = ("", nil)

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 500, height: 5)
                .foregroundColor(Color.blue)
                .cornerRadius(5)
            HStack {
                ForEach(dates, id: \.name) { date in
                    VStack {
                        Text(date.name).bold()
                        Image(systemName: "calendar")
                            .background(Color(.systemBackground))
                            .font(.title3)
                            .padding(1)
                        if let dateString = ArtemisDateHelpers.getRemainingOrOverdueTime(for: date.date) {
                            Text(dateString)
                        } else {
                            Text("Not available yet")
                        }
                    }
                    .frame(maxWidth: 150)
                    .padding(2)
                    .onTapGesture {
                        selectedDate = (date.name, date.date)
                        print(isShowingPopover)
                        isShowingPopover = true
                        print(isShowingPopover)
                    }
                }
            }
        }
        .popover(isPresented: $isShowingPopover) {
            VStack {
                Text("Due date for \(selectedDate.0)")
                selectedDate.1.map { date in
                    Text(ArtemisDateHelpers.getReadableDateString(date) ?? "Not available yet")
                }
            }
            .padding()
        }
    }
 }
