//
//  NavigationBarButtonStyle.swift
//  Themis
//
//  Created by Andreas Cselovszky on 10.01.23.
//

import SwiftUI

struct NavigationBarButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    var color = Color.themisSecondary
    var iconImageName: String?
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if let iconImageName {
                Image(iconImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 14, height: 6)
                    .foregroundColor(.white)
            }
            
            configuration.label
        }
        .foregroundColor(Color(.systemBackground))
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(isEnabled ? color : Color(.systemGray))
        .cornerRadius(5)
        .fontWeight(.semibold)
        .scaleEffect(configuration.isPressed ? 1.1 : 1)
        .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct NavigationBarButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Save", action: {})
            .buttonStyle(NavigationBarButton(iconImageName: "saveIcon"))
    }
}
