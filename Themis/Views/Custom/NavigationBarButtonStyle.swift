//
//  NavigationBarButtonStyle.swift
//  Themis
//
//  Created by Andreas Cselovszky on 10.01.23.
//

import SwiftUI

struct NavigationBarButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(.systemBackground))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isEnabled ? Color("customSecondary") : Color(.systemGray))
            .cornerRadius(20)
            .fontWeight(.semibold)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
