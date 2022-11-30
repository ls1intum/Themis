//
//  AuthenticationView.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authenticationVM: AuthenticationViewModel
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
                .textFieldStyle(LoginTextFieldStyle())
            TextField("username", text: $authenticationVM.username)
                .textFieldStyle(LoginTextFieldStyle())
            SecureField("password", text: $authenticationVM.password)
                .textFieldStyle(LoginTextFieldStyle())

            Toggle("Remember Session for 30 Days?", isOn: $authenticationVM.rememberMe)
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
                    Text("Login")
                }
            }
            .foregroundColor(.white)
            .frame(width: 500, height: 50)
            .background(Color.blue)
            .cornerRadius(10)
        }

    }

}

struct LoginTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .frame(width: 500, height: 50)
            .background(colorScheme == .light ? Color.black.opacity(0.1) : Color(uiColor: UIColor.systemGray6))
            .cornerRadius(10)
    }
}
