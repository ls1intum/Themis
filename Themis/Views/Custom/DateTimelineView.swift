//
//  TimelineView.swift
//  Themis
//
//  Created by Katjana Kosic on 02.02.23.
//

import SwiftUI

 struct DateTimelineView: View {
    let dates: [(name: String, date: String?)]

    var body: some View {
        HStack {
            ForEach(dates, id: \.name) { date in
                VStack {
                    Text(date.name)
                    Image(systemName: "calendar")
                        .font(.system(size: 30))
                        .padding(1)
                    if let dateString = ArtemisDateHelpers.getRemainingOrOverdueTime(for: date.date) {
                        Text(dateString)
                    } else {
                        Text("not available yet")
                    }
                }
                .frame(maxWidth: 150)
                .padding()
            }
        }
    }
 }
