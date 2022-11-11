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
        TextField("Artemis-Server", text: $authenticationVM.serverURL)
        TextField("username", text: $authenticationVM.username)
        TextField("password", text: $authenticationVM.password)
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
    }
}

