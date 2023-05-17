//
//  ToolbarToggleButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

/// A button that toggles the given variable
struct ToolbarToggleButton: View {
    /// The variable that this button should toggle
    @Binding var toggleVariable: Bool
    /// System name of the image that should be shown on the button
    var iconImageSystemName: String?
    
    var idleColor = Color.gray
    var activeColor = Color.yellow
    var inverted = false
    var text: String?
    
    var body: some View {
        Button {
            toggleVariable.toggle()
        } label: {
            if let iconImageSystemName {
                let iconDrawingColor: Color = (inverted ? !toggleVariable : toggleVariable) ? activeColor : idleColor
                Image(systemName: iconImageSystemName)
                    .symbolRenderingMode(.palette)
                    .foregroundColor(iconDrawingColor)
            }
            if let text {
                Text(text)
                    .foregroundColor(.white)
            }
        }
    }
}

struct PencilModeToggleButton_Previews: PreviewProvider {
    @State static var toggle = false
    
    static var previews: some View {
        ToolbarToggleButton(toggleVariable: $toggle, iconImageSystemName: "hand.draw", inverted: false)
            .previewLayout(.sizeThatFits)
    }
}
