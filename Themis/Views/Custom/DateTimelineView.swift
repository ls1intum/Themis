//
//  TimelineView.swift
//  Themis
//
//  Created by Katjana Kosic on 02.02.23.
//

import SwiftUI

struct DateTimelineView: View {
    @Environment(\.isEnabled) private var isEnabled
    
    let dates: [(name: String, date: Date?)]
    @State private var selectedDate: (String, Date?) = ("", nil)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(dates, id: \.name) { nameAndDateTuple in
                ZStack {
                    Rectangle()
                        .frame(height: 5)
                        .foregroundColor(getLineColor(for: nameAndDateTuple))
                    
                    VStack {
                        Text(nameAndDateTuple.name).bold()
                        
                        Image(systemName: "calendar")
                            .background(Color(.secondarySystemGroupedBackground))
                            .font(.title3)
                            .padding(1)
                        
                        Text(ArtemisDateHelpers.getRemainingOrOverdueTime(for: nameAndDateTuple.date))
                    }
                    .frame(maxWidth: 150)
                }
            }
        }
        .frame(maxWidth: 450)
    }
    
    private func getLineColor(for nameAndDateTuple: (name: String, date: Date?)) -> Color {
        (isEnabled && nameAndDateTuple.date != nil) ? Color.Artemis.artemisBlue : .gray
    }
}

struct DateTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimelineView(dates: [
            ("Yesterday", .yesterday),
            ("Today", .now),
            ("Tomorrow", .tomorrow)
        ])
    }
}
