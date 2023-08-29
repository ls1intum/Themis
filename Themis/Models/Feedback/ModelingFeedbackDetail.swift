//
//  ModelingFeedbackDetail.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 22.07.23.
//

import Foundation
import SharedModels

struct ModelingFeedbackDetail: FeedbackDetail {
    var umlItem: SelectableUMLItem?
    
    mutating func buildArtemisFeedback(feedback baseFeedback: inout Feedback) {
        baseFeedback.reference = "\(umlItem?.typeAsString ?? ""):\(umlItem?.id ?? "")"
    }
}
