//
//  Exercise.swift
//  feedback2go
//
//  Created by Tom Rudnick on 12.11.22.
//

import Foundation

struct Exercise: Codable {
    let id: Int
    let title: String?
    let shortName: String?
    let maxPoints: Double?
    let assessmentType: String?
    let problemStatement: String?
    let gradingInstructions: String?
}
