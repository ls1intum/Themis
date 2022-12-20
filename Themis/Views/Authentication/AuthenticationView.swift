//
//  AuthenticationView.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import SwiftUI

struct AuthenticationView: View {
    enum SecureFieldFocus { case plain, secure }

    @ObservedObject var authenticationVM: AuthenticationViewModel
    @State private var isSecured = true
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var passwordFocus: SecureFieldFocus?

    var body: some View {
        VStack {
            Image("AppIconVectorTransparent")
                .resizable()
                .frame(width: 300, height: 300)
            Text("Please sign in with your Artemis Account")
                .font(.title)
                .bold()
                .padding()
            TextField("Artemis-Server", text: $authenticationVM.serverURL)
                .textFieldStyle(LoginTextFieldStyle(validInput: authenticationVM.validURL))

            TextField("Username", text: $authenticationVM.username)
                .textFieldStyle(LoginTextFieldStyle())
                .textInputAutocapitalization(.never)
            passwordField
            Toggle("Remember me", isOn: $authenticationVM.rememberMe)
                .frame(width: 500)
                .padding()
            authenticateButton
        }.alert("Invalid Credentials", isPresented: $authenticationVM.invalidCredentialsAlert) {
            Button("Ok") {}
        }
    }

    var authenticateButton: some View {
        Button {
            Task {
                await authenticationVM.authenticate()
            }
        } label: {
            Group {
                if authenticationVM.authenticationInProgress {
                    ProgressView()
                } else {
                    Text("Sign in")
                }
            }
            .foregroundColor(.white)
            .frame(width: 500, height: 50)
            .background(authenticationVM.loginDisabled ? Color.gray : Color.blue)
            .cornerRadius(10)
        }.disabled(authenticationVM.loginDisabled)
    }

    var passwordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                SecureField("Password", text: $authenticationVM.password)
                    .focused($passwordFocus, equals: .secure)
                    .opacity(isSecured ? 1.0 : 0.0)
                TextField("Password", text: $authenticationVM.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .focused($passwordFocus, equals: .plain)
                    .opacity(!isSecured ? 1.0 : 0.0)
            }.padding(.trailing, 32)
            Button(action: {
                isSecured.toggle()
                passwordFocus = isSecured ? .secure : .plain
            }) {
                Image(systemName: self.isSecured ? "eye" : "eye.slash")
                    .accentColor(.gray)
            }
        }.padding()
        .frame(width: 500, height: 50)
        .background(colorScheme == .light ? Color.black.opacity(0.1) : Color(uiColor: UIColor.systemGray6))
        .cornerRadius(10)
    }
}

struct LoginTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    var validInput = true

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .frame(width: 500, height: 50)
            .background(validInput ? (colorScheme == .light ? Color.black.opacity(0.1) : Color(uiColor: UIColor.systemGray6)) : Color.red)
            .cornerRadius(10)
    }
}
