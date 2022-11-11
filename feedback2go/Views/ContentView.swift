//
//  ContentView.swift
//  feedback2go
//
//  Created by Florian Huber on 04.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authenticationVM = AuthenticationViewModel()
    var body: some View {
        VStack {
            if authenticationVM.authenticated {
                Text("Sie sind eingeloggt")
                Button {
                    authenticationVM.logout()
                } label: {
                    Text("Delete Token")
                }
            } else {
                AuthenticationView(authenticationVM: authenticationVM)
            }
        }
        .onAppear {
            authenticationVM.searchForToken()
        }
        .alert("Invalid Credentials", isPresented: $authenticationVM.invalidCredentialsAlert, actions: {
            Button("Ok"){}
        })
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
