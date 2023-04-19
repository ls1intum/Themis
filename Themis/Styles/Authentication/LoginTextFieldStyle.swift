//
//  LoginTextFieldStyle.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.04.23.
//

import SwiftUI

struct LoginTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    @Binding var error: Error?
    var validInput = true
    var type: AuthTextFieldType

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .frame(width: 500, height: 50)
            .background(validInput ? (colorScheme == .light ? Color.black.opacity(0.1) : Color(uiColor: UIColor.systemGray6)) : Color.red)
            .cornerRadius(10)
            .overlay {
                if error != nil && type == .username {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red.opacity(0.4), lineWidth: 2)
                }
            }
    }
}
