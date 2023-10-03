//
//  FileUploadAssessmentResult.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 14.09.23.
//

import Foundation
import SharedModels

class FileUploadAssessmentResult: AssessmentResult {
    override func encode(to encoder: Encoder) throws {
        try FileUploadAssessmentResultDTO(basedOn: self).encode(to: encoder)
    }
}

struct FileUploadAssessmentResultDTO: Encodable {
    let feedbacks: [Feedback]
    
    init(basedOn fileUploadAssessmentResult: FileUploadAssessmentResult) {
        self.feedbacks = fileUploadAssessmentResult.feedbacks.map({ $0.baseFeedback })
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(contentsOf: feedbacks)
    }
}
