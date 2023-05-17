//
//  AuthenticationView.swift
//  Themis
//
//  Created by Tom Rudnick on 11.11.22.
//

import SwiftUI

struct AuthenticationView: View {
    enum SecureFieldFocus { case plain, secure }
    enum FocusedField { case serverurl, username, password }

    @ObservedObject var authenticationVM: AuthenticationViewModel
    @State private var isSecured = true
    @State var invalidAttempts: Int = 0
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var passwordFocus: SecureFieldFocus?
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack {
            Image("AppIconVectorTransparent")
                .resizable()
                .frame(width: 300, height: 300)
            
            Text("Welcome to Themis!")
                .font(.title)
                .bold()
                .padding()
            
            Text("Please sign in with your Artemis account")
                .font(.headline)
                .padding()
            
            TextField("Artemis-Server", text: $authenticationVM.serverURL)
                .textFieldStyle(LoginTextFieldStyle(error: $authenticationVM.error, validInput: authenticationVM.validURL, type: .serverURL))
                .focused($focusedField, equals: .serverurl)
                .submitLabel(.next)
            
            TextField("Username", text: $authenticationVM.username)
                .textFieldStyle(LoginTextFieldStyle(error: $authenticationVM.error, type: .username))
                .textInputAutocapitalization(.never)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
            
            passwordField
                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
            
            Toggle("Remember me", isOn: $authenticationVM.rememberMe)
                .frame(width: 500)
                .padding()
            
            authenticateButton
        }
        .onSubmit {
            switch focusedField {
            case .serverurl:
                focusedField = .username
            case .username:
                focusedField = .password
            case .password:
                Task {
                    await authenticationVM.authenticate()
                }
                focusedField = nil
            case .none:
                focusedField = nil
            }
        }
    }

    var authenticateButton: some View {
        Button {
            Task {
                await authenticationVM.authenticate()
                if authenticationVM.error != nil {
                    withAnimation(.linear) {
                        self.invalidAttempts += 1
                    }
                }
            }
            // reset error and failed attempts if login successful
            withAnimation(.easeOut(duration: 0.3)) {
                authenticationVM.error = nil
                self.invalidAttempts = 0
            }
        } label: {
            Group {
                if authenticationVM.authenticationInProgress {
                    ProgressView()
                } else {
                    Text("Sign in")
                }
            }
        }
        .disabled(authenticationVM.loginDisabled)
        .buttonStyle(LoginButtonStyle(loginDisabled: authenticationVM.loginDisabled))
    }
    
    private var serverURLField: some View {
        TextField("Artemis-Server", text: $authenticationVM.serverURL)
            .textFieldStyle(LoginTextFieldStyle(error: $authenticationVM.error, validInput: authenticationVM.validURL, type: .serverURL))
            .focused($focusedField, equals: .serverurl)
            .submitLabel(.next)
    }
    
    private var usernameField: some View {
        TextField("Username", text: $authenticationVM.username)
            .textFieldStyle(LoginTextFieldStyle(error: $authenticationVM.error, type: .username))
            .textInputAutocapitalization(.never)
            .focused($focusedField, equals: .username)
            .submitLabel(.next)
            .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
    }

    private var passwordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                SecureField("Password", text: $authenticationVM.password)
                    .focused($passwordFocus, equals: .secure)
                    .opacity(isSecured ? 1.0 : 0.0)
                TextField("Password", text: $authenticationVM.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .focused($passwordFocus, equals: .plain)
                    .opacity(!isSecured ? 1.0 : 0.0)
            }
            .focused($focusedField, equals: .password)
            .submitLabel(.join)
            .padding(.trailing, 32)
            Button(action: {
                isSecured.toggle()
                passwordFocus = isSecured ? .secure : .plain
            }) {
                Image(systemName: self.isSecured ? "eye" : "eye.slash")
                    .accentColor(.gray)
            }
        }.padding()
        .frame(width: 500, height: 50)
        .background(colorScheme == .light ? Color.black.opacity(0.1) : Color(uiColor: UIColor.systemGray6))
        .cornerRadius(10)
        .overlay {
            if authenticationVM.error != nil {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.red.opacity(0.4), lineWidth: 3)
            }
        }
    }
}

enum AuthTextFieldType {
    case serverURL, username
}

struct AuthenticationView_Previews: PreviewProvider {
    static var vm = AuthenticationViewModel()
    
    static var previews: some View {
        AuthenticationView(authenticationVM: vm)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
