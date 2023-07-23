//
//  ModelingFeedbackDetail.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 22.07.23.
//

import Foundation
import SharedModels

struct ModelingFeedbackDetail: FeedbackDetail {
    var element: UMLElement?
    
    mutating func buildArtemisFeedback(feedback baseFeedback: inout Feedback) {
        
        // TODO: implement
        baseFeedback.reference = "not implemented yet"
    }
}
