//
//  AuthenticationView.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import SwiftUI

struct AuthenticationView: View {
    enum SecureFieldFocus { case plain, secure }
    enum FocusedField { case serverurl, username, password }

    @ObservedObject var authenticationVM: AuthenticationViewModel
    @State private var isSecured = true
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var passwordFocus: SecureFieldFocus?
    @FocusState private var focusedField: FocusedField?

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
                .focused($focusedField, equals: .serverurl)
                .submitLabel(.next)

            TextField("Username", text: $authenticationVM.username)
                .textFieldStyle(LoginTextFieldStyle())
                .textInputAutocapitalization(.never)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
            passwordField
            Toggle("Remember me", isOn: $authenticationVM.rememberMe)
                .frame(width: 500)
                .padding()
            authenticateButton
        }
        .onSubmit {
            switch focusedField {
            case .serverurl:
                focusedField = .username
            case .username:
                focusedField = .password
            case .password:
                Task {
                    await authenticationVM.authenticate()
                }
                focusedField = nil
            case .none:
                focusedField = nil
            }
        }
        .alert("Invalid Credentials", isPresented: $authenticationVM.invalidCredentialsAlert) {
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
            }
            .focused($focusedField, equals: .password)
            .submitLabel(.join)
            .padding(.trailing, 32)
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
