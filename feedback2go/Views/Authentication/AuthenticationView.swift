//
//  AuthenticationView.swift
//  feedback2go
//
//  Created by Tom Rudnick on 11.11.22.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authenticationVM: AuthenticationViewModel
    var body: some View {
        VStack {
            TextField("Artemis-Server", text: $authenticationVM.serverURL)
            TextField("username", text: $authenticationVM.username)
            SecureField("password", text: $authenticationVM.password)
            HStack {
                Text("Remember Session for 30 Days?")
                rememberMe
            }
            if authenticationVM.authenticationInProgress {
                ProgressView()
            }
            Button {
                Task {
                    await authenticationVM.authenticate()
                }
            } label: {
                Text("Log-In")
            }
        }.alert("Invalid Credentials", isPresented: $authenticationVM.invalidCredentialsAlert, actions: {
            Button("Ok"){}
        })
        
    }
    
    var rememberMe: some View {
        Image(systemName: authenticationVM.rememberMe ? "checkmark.square.fill" : "square")
            .foregroundColor(authenticationVM.rememberMe ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.authenticationVM.rememberMe.toggle()
            }
    }
}

