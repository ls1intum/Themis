//
//  CorrectionHelpView.swift
//  feedback2go
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

enum CorrectionSidebarElements {
  case problemStatement, correctionGuidelines, generalFeedback
}

struct CorrectionSidebarView: View {
    @StateObject var feedbackModel = FeedbackViewModel.mock
    @StateObject var correctionGuidelines = CorrectionGuidelines.mock
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
                    CorrectionGuidelinesCellView(correctionGuidelinesModel: correctionGuidelines)
                case .generalFeedback:
                    GeneralFeedbackCellView(feedbackModel: feedbackModel)
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
