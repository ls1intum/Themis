//
//  TextFeedbackDetail.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.06.23.
//

import Foundation
import SharedModels

public struct TextFeedbackDetail: FeedbackDetail {
    var block: TextBlock

    public mutating func buildArtemisFeedback(feedback baseFeedback: inout SharedModels.Feedback) {
        block.computeId()
        
        baseFeedback.reference = block.id
    }
}
