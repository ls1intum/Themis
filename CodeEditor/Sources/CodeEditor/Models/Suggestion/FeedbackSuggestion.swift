//
//  FeedbackSuggestion.swift
//  
//
//  Created by Tarlan Ismayilsoy on 29.08.23.
//

import Foundation

public protocol FeedbackSuggestion: Equatable {
    var id: UUID { get }
    var text: String { get }
    var credits: Double { get }
}

public extension FeedbackSuggestion {
    var text: String { "" }
    var credits: Double { 0.0 }
}
