//
//  EditFeedbackView.swift
//  Themis
//
//  Created by Paul Schwind on 14.12.22.
//

import SwiftUI
import SharedModels

struct EditFeedbackView: View {
    var assessmentResult: AssessmentResult
    weak var feedbackDelegate: (any FeedbackDelegate)?
    
    let scope: ThemisFeedbackScope
    let idForUpdate: UUID
    let gradingCriteria: [GradingCriterion]
    
    @Binding var showSheet: Bool
    
    var body: some View {
        EditFeedbackViewBase(
            assessmentResult: assessmentResult,
            feedbackDelegate: feedbackDelegate,
            idForUpdate: idForUpdate,
            scope: scope,
            gradingCriteria: gradingCriteria,
            showSheet: $showSheet
        )
    }
}
