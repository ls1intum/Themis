//
//  TextAsessmentResult.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 09.06.23.
//

import Foundation
import SharedModels
import Common

class TextAssessmentResult: AssessmentResult {
    var resultId: Int?
    var blocks: [TextBlock] = []
    
    init(resultId: Int? = nil) {
        super.init()
        self.resultId = resultId
    }
    
    override func reset() {
        self.resultId = nil
        self.blocks = []
    }
    
    override func setReferenceData(basedOn submission: BaseSubmission?) {
        guard let textSubmission = submission as? TextSubmission,
              let submissionId = textSubmission.id
        else {
            log.warning("Could not set reference data for TextAssessmentResult")
            return
        }
        
        blocks = textSubmission.blocks ?? []
        assignSubmissionIdToBlocks(submissionId)
    }
    
    func computeBlockIds() {
        var newBlocks = [TextBlock]()
        
        for block in self.blocks {
            var blockClone = block
            blockClone.computeId()
            newBlocks.append(blockClone)
        }
        
        self.blocks = newBlocks
    }
    
    private func assignSubmissionIdToBlocks(_ submissionId: Int) {
        for index in 0..<blocks.count {
            self.blocks[index].submissionId = submissionId
        }
    }
    
    private func extractBlock(from feedback: AssessmentFeedback) -> TextBlock? {
        guard let detail = feedback.detail as? TextFeedbackDetail else {
            return nil
        }
        return detail.block
    }
    
    override func addFeedback(feedback: AssessmentFeedback) {
        super.addFeedback(feedback: feedback)
        if let block = extractBlock(from: feedback) {
            self.blocks.append(block)
        }
    }

    override func deleteFeedback(id: UUID) -> AssessmentFeedback? {
        guard let deletedFeedback = super.deleteFeedback(id: id) else {
            return nil
        }
        self.blocks.removeAll(where: { $0.id == deletedFeedback.baseFeedback.reference })
        return deletedFeedback
    }

    override func updateFeedback(feedback: AssessmentFeedback) -> AssessmentFeedback? {
        guard let updatedFeedback = super.updateFeedback(feedback: feedback),
              let updatedBlock = (updatedFeedback.detail as? TextFeedbackDetail)?.block,
              let existingBlockIndex = self.blocks.firstIndex(where: { $0.id == feedback.baseFeedback.reference })
        else {
            return nil
        }
        self.blocks[existingBlockIndex] = updatedBlock
        return updatedFeedback
    }
    
    override func encode(to encoder: Encoder) throws {
        try TextAssessmentResultDTO(basedOn: self).encode(to: encoder)
    }
}

struct TextAssessmentResultDTO: Encodable {
    let feedbacks: [Feedback]
    let textBlocks: [TextBlock]
    
    init(basedOn textAssessmentResult: TextAssessmentResult) {
        self.feedbacks = textAssessmentResult.feedbacks.map({ $0.baseFeedback })
        self.textBlocks = textAssessmentResult.blocks
    }
}
