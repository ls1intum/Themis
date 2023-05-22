//
//  ProblemStatementView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 22.05.23.
//

import SwiftUI
import DesignLibrary
import UserStore

/// A view that loads a standalone problem statement page in a WebView
struct ProblemStatementView: View {
    @State private var request: URLRequest
    @State private var height: CGFloat = .l
    @State private var isLoading = true
    
    init(courseId: Int, exerciseId: Int) {
        if let url = URL(string: "/courses/\(courseId)/exercises/\(exerciseId)/problem-statement", relativeTo: UserSession.shared.institution?.baseURL) {
            self._request = State(wrappedValue: URLRequest(url: url))
        } else {
            // swiftlint:disable:next force_unwrapping
            self._request = State(wrappedValue: URLRequest(url: URL(string: "https://google.com")!))
        }
    }
    
    var body: some View {
        ZStack {
            ArtemisWebView(urlRequest: $request,
                           contentHeight: $height,
                           isLoading: $isLoading)
            .disabled(true)
            .frame(height: isLoading ? 0 : height)
            
            ProgressView()
                .isHidden(!isLoading, remove: true)
        }
        .frame(height: height)
    }
}

struct ProblemStatementView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            ProblemStatementView(courseId: 3342, exerciseId: 5284)
        }
    }
}
