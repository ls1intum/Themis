//
//  Assessment.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

// swiftlint:disable line_length

import Foundation

enum FeedbackType {
    case inline
    case general
}

/// class to share UndoManager between CodeEditorViewModel and AssessmentResult
class UndoManagerSingleton {
    static let shared = UndoManagerSingleton()
    let undoManager = UndoManager()
}

class AssessmentResult: Encodable, ObservableObject {
    let undoManager = UndoManagerSingleton.shared.undoManager
    
    var score: Double {
        let score = feedbacks.reduce(0) { $0 + $1.credits }
        return score < 0 ? 0 : score
    }

    @Published var feedbacks: [AssessmentFeedback] = [] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.feedbacks = oldValue
            }
        }
    }

    var computedFeedbacks: [AssessmentFeedback] {
        get {
            feedbacks
        }
        set(new) {
            feedbacks = new.sorted(by: >).sorted {
                $0.assessmentType.isManual && $1.assessmentType.isAutomatic
            }
        }
    }

    enum CodingKeys: CodingKey {
        case score
        case feedbacks
        case testCaseCount
        case passedTestCaseCount
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(score, forKey: .score)
        try container.encode(feedbacks, forKey: .feedbacks)
        try container.encode(automaticFeedback.count, forKey: .testCaseCount)
        try container.encode(automaticFeedback.filter { $0.positive } .count, forKey: .passedTestCaseCount)
    }

    var generalFeedback: [AssessmentFeedback] {
        feedbacks
            .filter { $0.type == .general && $0.assessmentType.isManual }
    }

    var inlineFeedback: [AssessmentFeedback] {
        feedbacks
            .filter { $0.type == .inline && $0.assessmentType.isManual }
    }

    var automaticFeedback: [AssessmentFeedback] {
        feedbacks.filter { $0.assessmentType.isAutomatic }
    }

    func addFeedback(feedback: AssessmentFeedback) {
        if feedback.type == .inline {
            undoManager.beginUndoGrouping() /// undo group with addInlineHighlight in CodeEditorViewModel
        }
        computedFeedbacks.append(feedback)
        print(computedFeedbacks.count)
    }

    func deleteFeedback(id: UUID) {
        if computedFeedbacks.contains(where: { $0.id == id && $0.type == .inline }) {
             undoManager.beginUndoGrouping() /// undo group with addInlineHighlight in CodeEditorViewModel
         }
        computedFeedbacks.removeAll { $0.id == id }
        print(computedFeedbacks.count)
    }

    func updateFeedback(id: UUID, detailText: String, credits: Double) {
        guard let index = (feedbacks.firstIndex { $0.id == id }) else {
            return
        }
        computedFeedbacks[index].detailText = detailText
        computedFeedbacks[index].credits = credits
    }
    
    func undo() {
        undoManager.undo()
    }
    
    func redo() {
        undoManager.redo()
    }
    
    func canUndo() -> Bool {
        undoManager.canUndo
    }
    
    func canRedo() -> Bool {
        undoManager.canRedo
    }
}

struct AssessmentFeedback: Identifiable, Hashable {
    // attributes from artemis
    let id = UUID()
    let created = Date()
    var text: String? /// max length = 500
    var detailText: String? /// max length = 5000
    var reference: String?
    var credits: Double /// score of element
    var assessmentType: AssessmentType = .MANUAL
    var positive: Bool

    // custom utility attributes
    var type: FeedbackType
    var file: Node?

    init(
        text: String? = nil,
        detailText: String? = nil,
        credits: Double,
        assessmentType: AssessmentType = .MANUAL,
        type: FeedbackType,
        file: Node? = nil,
        lines: NSRange? = nil,
        columns: NSRange? = nil
    ) {
        self.text = text
        self.detailText = detailText
        self.credits = credits
        self.assessmentType = assessmentType
        self.type = type
        self.file = file
        self.positive = true
        self.buildLineDescription(lines: lines, columns: columns)
    }

    mutating func updateFeedback(detailText: String, credits: Double) {
        self.detailText = detailText
        self.credits = credits
    }

    mutating func buildLineDescription(lines: NSRange?, columns: NSRange?) {
        guard let file = file, let lines = lines else {
            return
        }
        if lines.location == 0 {
            return
        }
        self.reference = "file:" + file.path + "_line:\(lines.location)"
        guard let columns else {
            self.text = "File " + file.path + " at lines \(lines.location)-\(lines.location + lines.length)"
            return
        }
        if columns.length == 0 {
            self.text = "File " + file.path + " at line \(lines.location) column \(columns.location)"
        } else {
            self.text = "File " + file.path + " at line \(lines.location) column \(columns.location)-\(columns.location + columns.length)"
        }
    }
}

// send to artemis
extension AssessmentFeedback: Encodable {
    enum EncodingKeys: String, CodingKey {
        case text
        case detailText
        case reference
        case credits
        case positive
        case assessmentType = "type"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(detailText, forKey: .detailText)
        try container.encode(reference, forKey: .reference)
        try container.encode(credits, forKey: .credits)
        try container.encode(positive, forKey: .positive)
        try container.encode(assessmentType, forKey: .assessmentType)
    }
}

// receive feedbacks from artemis
extension AssessmentFeedback: Decodable {
    enum DecodingKeys: String, CodingKey {
        case text
        case detailText
        case credits
        case assessmentType = "type"
        case positive
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        text = try? values.decode(String?.self, forKey: .text)
        detailText = try? values.decode(String?.self, forKey: .detailText)
        credits = try values.decode(Double?.self, forKey: .credits) ?? 0.0
        assessmentType = try values.decode(AssessmentType.self, forKey: .assessmentType)
        // assessment type `MANUAL_UNREFERENCED` does not have positive
        positive = (try? values.decode(Bool?.self, forKey: .positive)) ?? false
        type = text?.contains("at line") ?? false ? .inline : .general
    }
}

extension AssessmentFeedback: Comparable {
    static func < (lhs: AssessmentFeedback, rhs: AssessmentFeedback) -> Bool {
        lhs.created < rhs.created
    }
}

// https://github.com/ls1intum/Artemis/blob/develop/src/main/java/de/tum/in/www1/artemis/domain/enumeration/FeedbackType.java
enum AssessmentType: String, Codable {
    case AUTOMATIC
    case AUTOMATIC_ADAPTED
    case MANUAL
    case MANUAL_UNREFERENCED
    
    var isManual: Bool {
        self == .MANUAL || self == .MANUAL_UNREFERENCED
    }
    
    var isAutomatic: Bool {
        self == .AUTOMATIC || self == .AUTOMATIC_ADAPTED
    }
}

extension ArtemisAPI {

    /// delete all saved feedback and release the lock of the submission
    static func cancelAssessment(submissionId: Int) async throws {
        let request = Request(method: .put, path: "/api/programming-submissions/\(submissionId)/cancel-assessment")
        _ = try await sendRequest(String.self, request: request)
    }

    /// save feedback to the submission
    static func saveAssessment(participationId: Int, newAssessment: AssessmentResult, submit: Bool) async throws {
        let request = Request(method: .put,
                              path: "/api/participations/\(participationId)/manual-results",
                              params: [URLQueryItem(name: "submit", value: String(submit))],
                              body: newAssessment)
        try await sendRequest(request: request)
    }
}
