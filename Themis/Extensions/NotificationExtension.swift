//
//  NotificationExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 12.06.23.
//

import Foundation

extension Notification.Name {
    /// A notification intended to notify all subscribers that the user has started a new assessment after submitting a previous one.
    static let nextAssessmentStarted = Self("NextAssessmentStarted")
}
