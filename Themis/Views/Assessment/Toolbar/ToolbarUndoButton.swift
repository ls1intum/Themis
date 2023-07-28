//
//  ToolbarUndoButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI
import Combine

struct ToolbarUndoButton: View {
    
    @State private var canUndo = false
    private let undoManager = ThemisUndoManager.shared
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                undoManager.undo()
            }
        } label: {
            let undoIconColor: Color = canUndo ? .white : .gray
            Image(systemName: "arrow.uturn.backward")
                .foregroundStyle(undoIconColor)
        }
        .disabled(!canUndo)
        .onReceive(NotificationCenter.default.publisher(for: undoManager.stateChangeNotification), perform: { _ in
            canUndo = undoManager.canUndo
        })
    }
}

struct UndoManagerButtons_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarUndoButton()
    }
}
