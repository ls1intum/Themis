//
//  ToolbarRedoButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI
import Combine

struct ToolbarRedoButton: View {
    
    @State private var canRedo = false
    private let undoManager = ThemisUndoManager.shared

    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                undoManager.redo()
            }
        } label: {
            let redoIconColor: Color = canRedo ? .white : .gray
            Image(systemName: "arrow.uturn.forward")
                .foregroundStyle(redoIconColor)
        }
        .disabled(!canRedo)
        .onReceive(NotificationCenter.default.publisher(for: undoManager.stateChangeNotification), perform: { _ in
            canRedo = undoManager.canRedo
        })
    }
}

struct ToolbarRedoButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarRedoButton()
    }
}
