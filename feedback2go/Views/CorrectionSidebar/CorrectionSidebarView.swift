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
    @State var correctionSidebarStatus = CorrectionSidebarElements.problemStatement

    var body: some View {
        VStack {
            Picker(selection: $correctionSidebarStatus, label: Text("")) {
                Text("Problem Statement")
                    .tag(CorrectionSidebarElements.problemStatement)
                Text("Correction Guidelines")
                    .tag(CorrectionSidebarElements.correctionGuidelines)
                Text("General Feedback")
                    .tag(CorrectionSidebarElements.generalFeedback)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Text(feedbackModel.getFeedbackText(id: feedbackModel.feedbacks[0].id))

            ScrollView {
                switch correctionSidebarStatus {
                case .problemStatement:
                    ProblemStatementCellView()
                case .correctionGuidelines:
                    CorrectionGuidelinesCellView()
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
