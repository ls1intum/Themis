//
//  CorrectionHelpView.swift
//  Themis
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

enum CorrectionSidebarElements {
  case problemStatement, correctionGuidelines, generalFeedback
}

struct CorrectionSidebarView: View {
    @StateObject var feedBackViewModel = FeedbackViewModel()

    @State var correctionSidebarStatus = CorrectionSidebarElements.problemStatement

    var body: some View {
        VStack {
            Picker(selection: $correctionSidebarStatus, label: Text("")) {
                Text("Problem")
                    .tag(CorrectionSidebarElements.problemStatement)
                Text("Guidelines")
                    .tag(CorrectionSidebarElements.correctionGuidelines)
                Text("Feedback")
                    .tag(CorrectionSidebarElements.generalFeedback)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ScrollView {
                switch correctionSidebarStatus {
                case .problemStatement:
                    ProblemStatementCellView()
                case .correctionGuidelines:
                    CorrectionGuidelinesCellView()
                case .generalFeedback:
                    GeneralFeedbackCellView()
                }
            }
        }
    }
}

struct CorrectionSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionSidebarView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
