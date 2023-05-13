//
//  LoginButtonStyle.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.04.23.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    var loginDisabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width: 500, height: 50)
            .background(loginDisabled ? Color.gray : Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
