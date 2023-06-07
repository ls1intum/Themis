//
//  FeedbackDetail.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.06.23.
//

import Foundation
import SharedModels

public protocol FeedbackDetail {
    var id: UUID { get }
    /// Populates the properties of the given `Feedback` instance
    mutating func buildArtemisFeedback(feedback baseFeedback: inout Feedback)
}

extension FeedbackDetail {
    public var id: UUID { UUID() }
}
