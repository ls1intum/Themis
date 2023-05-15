//
//  ToolbarUndoButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI
import Combine

struct ToolbarUndoButton: View {
    private var cancellables: Set<AnyCancellable> = Set()

    init() {
        UndoManager.shared.publisher(for: \.canUndo).sink { _ in }.store(in: &cancellables)
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                UndoManager.shared.undo()
            }
        } label: {
            let undoIconColor: Color = UndoManager.shared.canUndo ? .white : .gray
            Image(systemName: "arrow.uturn.backward")
                .foregroundStyle(undoIconColor)
        }
        .disabled(!UndoManager.shared.canUndo)
    }
}

struct UndoManagerButtons_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarUndoButton()
    }
}
