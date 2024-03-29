//
//  CourseExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 03.05.23.
//

import Foundation
import SharedModels

extension Course {
    static func == (lhs: Course, rhs: Course) -> Bool {
        // exercises are not equated
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.description == rhs.description && lhs.shortName == rhs.shortName
    }
}
