//
//  TextExerciseRendererViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 30.05.23.
//

import Foundation
import SharedModels

class TextExerciseRendererViewModel: ObservableObject {
    @Published var content: String? = "Loading..."
    @Published var fontSize: CGFloat = 18.0
    
    var wordCount: Int {
        let wordRegex = /[\w\u00C0-\u00ff]+/
        return content?.matches(of: wordRegex).count ?? 0
    }
    
    var charCount: Int {
        content?.count ?? 0
    }
    
    @MainActor
    func setContent(basedOn submission: BaseSubmission?) {
        content = submission?.get(as: TextSubmission.self)?.text ?? content
    }
}
