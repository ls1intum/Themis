//
//  ContentView.swift
//  Themis
//
//  Created by Florian Huber on 04.11.22.
//

import SwiftUI
import Login
import UserStore

struct ContentView: View {
    @StateObject private var rootVM = RootViewModel()
    
    var body: some View {
        VStack {
            if rootVM.isLoggedIn {
                CourseView()
            } else {
                AuthenticationView()
            }
        }
    }
}

 struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
 }
