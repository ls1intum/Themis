//
//  ProgrammingFeedbackDetail.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.06.23.
//

import Foundation
import SharedModels

public struct ProgrammingFeedbackDetail: FeedbackDetail {
    var file: Node?
    var lines: NSRange?
    var columns: NSRange?
    
    public mutating func buildArtemisFeedback(feedback baseFeedback: inout Feedback) {
        guard let file = file, let lines = lines else {
            return
        }
        if lines.location == 0 {
            return
        }
        
        let filePath = file.path.removeLeadingSlashIfExists()
        
        baseFeedback.reference = "file:" + filePath + "_line:\(lines.location)"
        
        guard let columns else {
            if lines.length == 0 {
                baseFeedback.text = "File " + filePath + " at line \(lines.location)"
            } else {
                baseFeedback.text = "File " + filePath + " at lines \(lines.location)-\(lines.location + lines.length)"
            }
            return
        }
        if columns.length == 0 {
            baseFeedback.text = "File " + filePath + " at line \(lines.location) column \(columns.location)"
        } else {
            baseFeedback.text = "File " + filePath + " at line \(lines.location) column \(columns.location)-\(columns.location + columns.length)"
        }
    }
}
