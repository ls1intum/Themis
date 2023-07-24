//
//  ExerciseRendererViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.07.23.
//

import Foundation

/// A class that unifies the common properties for viewmodels used for rendering exercises on the assessment window
class ExerciseRendererViewModel: ObservableObject {
    @Published var fontSize: CGFloat = 18.0
    /// True if the sheet for adding a new feedback should be shown
    @Published var showAddFeedback = false
    /// True if the sheet for editing an existing feedback should be shown
    @Published var showEditFeedback = false
    /// The ID of the feedback currently being edited
    @Published var selectedFeedbackForEditingId = UUID()
    /// The ID of the feedback suggestion that was selected
    @Published var selectedFeedbackSuggestionId = ""
    /// If true, the user is allowed to add referenced feedbacks
    @Published var pencilMode = true
    @Published var isLoading = false
    
    let undoManager = ThemisUndoManager.shared
}
