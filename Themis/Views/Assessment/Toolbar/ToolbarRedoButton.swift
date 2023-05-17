//
//  ToolbarRedoButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI
import Combine

struct ToolbarRedoButton: View {
    private var cancellables: Set<AnyCancellable> = Set()
    
    init() {
        UndoManager.shared.publisher(for: \.canRedo).sink { _ in }.store(in: &cancellables)
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                UndoManager.shared.redo()
            }
        } label: {
            let redoIconColor: Color = UndoManager.shared.canRedo ? .white : .gray
            Image(systemName: "arrow.uturn.forward")
                .foregroundStyle(redoIconColor)
        }
        .disabled(!UndoManager.shared.canRedo)
    }
}

struct ToolbarRedoButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarRedoButton()
    }
}
