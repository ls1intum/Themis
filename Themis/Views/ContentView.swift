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
        // SubmissionListView(exerciseId: 5284)
        VStack {
            if authenticationVM.authenticated {
                // AssessmentView()
                CourseListView(authenticationVM: authenticationVM)
                // SubmissionListView(exerciseId: 5284)
            } else {
                AuthenticationView(authenticationVM: authenticationVM)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authenticationVM: PreviewAuthenticationViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
