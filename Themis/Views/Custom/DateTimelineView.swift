//
//  TimelineView.swift
//  Themis
//
//  Created by Katjana Kosic on 02.02.23.
//

import SwiftUI

// struct DateTimelineView: View {
//    let dates: [(name: String, date: String?)]
//
//     var body: some View {
//         ZStack(alignment: .center) {
//             Rectangle()
//                 .frame(width: 650, height: 6)
//                 .foregroundColor(Color.blue)
//             HStack {
//                 ForEach(dates, id: \.name) { date in
//                     VStack {
//                         Text(date.name)
//                         Image(systemName: "calendar")
//                             .background(Color.white)
//                             .font(.system(size: 30))
//                             .padding(1)
//                         if let dateString = ArtemisDateHelpers.getRemainingOrOverdueTime(for: date.date) {
//                             Text(dateString)
//                         } else {
//                             Text("not available yet")
//                         }
//                     }
//                     .frame(maxWidth: 150)
//                     .padding()
//                 }
//             }
//         }
//    }
// }
struct DateTimelineView: View {
    let dates: [(name: String, date: String?)]
    @State private var showExactDate = false
    @State private var selectedDate: String?

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
                            .onLongPressGesture(minimumDuration: 3.0, maximumDistance: 10, pressing: {_ in
                                selectedDate = date.date
                                showExactDate.toggle()
                            }, perform: {
                                showExactDate = false
                            })
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
        .alert(isPresented: $showExactDate) {
            if let date = selectedDate, let dateString = ArtemisDateHelpers.getReadableDateString(date) {
                return Alert(title: Text("Date"), message: Text(dateString), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Date"), message: Text("Not available yet"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
