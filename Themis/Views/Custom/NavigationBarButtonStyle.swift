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
            .background(isEnabled ? Color.secondary : Color(.systemGray))
            .cornerRadius(20)
            .fontWeight(.semibold)
    }
}
