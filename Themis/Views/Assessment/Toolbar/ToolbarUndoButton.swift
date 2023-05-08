//
//  ToolbarUndoButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct ToolbarUndoButton: View {
    var assessmentResult: AssessmentResult
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                assessmentResult.undo()
            }
        } label: {
            let undoIconColor: Color = assessmentResult.canUndo() ? .white : .gray
            Image(systemName: "arrow.uturn.backward")
                .foregroundStyle(undoIconColor)
        }
        .disabled(!assessmentResult.canUndo())
    }
}

struct UndoManagerButtons_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarUndoButton(assessmentResult: AssessmentResult())
    }
}
