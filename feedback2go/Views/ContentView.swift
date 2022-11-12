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
                CourseListView(authenticationVM: authenticationVM)
            } else {
                AuthenticationView(authenticationVM: authenticationVM)
            }
        }
        .onAppear {
            authenticationVM.searchForToken()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
