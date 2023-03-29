//
//  ContentView.swift
//  Themis
//
//  Created by Florian Huber on 04.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authenticationVM = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            if authenticationVM.authenticated {
                CourseView(authenticationVM: authenticationVM)
            } else {
                AuthenticationView(authenticationVM: authenticationVM)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authenticationVM: PreviewAuthenticationViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
