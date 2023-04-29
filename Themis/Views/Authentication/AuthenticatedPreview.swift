//
//  AuthenticatedPreview.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//


import SwiftUI

/// Wrap your preview with this component if you need authentication.
struct AuthenticatedPreview<Content: View>: View {
    @StateObject var authenticationVM = PreviewAuthenticationViewModel()
    let contentBuilder: () -> Content

    @ViewBuilder
    var body: some View {
        if authenticationVM.authenticated {
            contentBuilder()
        } else {
            Text("Authenticating...")
        }
    }
}
