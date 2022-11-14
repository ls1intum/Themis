//
//  Assessment.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation


/// delete all saved feedback and release the lock of the submission
struct CancelAssessment: APIRequest {
    let submissionId: Int
    var request: Request {
        Request(method: .put, path: "/api/programming-submissions/\(submissionId)/cancel-assessment")
    }
}

/// save feedback to the submission
struct SaveAssessment: APIRequest {
    let participationId: Int
    let newAssessment: String //TODO: find what body has to be pushed
    var request: Request {
        Request(method: .post, path: "/participations/\(participationId)/manual-results", body: newAssessment)
    }
}

/// delete all feedback of submission
struct DeleteAssessment: APIRequest {
    let participationId: Int
    let submissionId: Int
    let resultId: Int
    var request: Request {
        Request(method: .delete, path: "/api/participations/\(participationId)/programming-submissions/\(submissionId)/results/\(resultId)")
    }
}
