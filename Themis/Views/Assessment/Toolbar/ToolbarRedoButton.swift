//
//  ToolbarRedoButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct ToolbarRedoButton: View {
    var assessmentResult: AssessmentResult
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                assessmentResult.redo()
            }
        } label: {
            let redoIconColor: Color = assessmentResult.canRedo() ? .white : .gray
            Image(systemName: "arrow.uturn.forward")
                .foregroundStyle(redoIconColor)
        }
        .disabled(!assessmentResult.canRedo())
    }
}

struct ToolbarRedoButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarRedoButton(assessmentResult: AssessmentResult())
    }
}
