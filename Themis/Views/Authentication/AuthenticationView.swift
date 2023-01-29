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
            Text("Please sign in with your Artemis Account")
                .font(.title)
                .bold()
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
                        print(invalidAttempts)
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

    var passwordField: some View {
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

struct LoginTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    @Binding var error: Error?
    var validInput = true
    var type: TextFieldType

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .frame(width: 500, height: 50)
            .background(validInput ? (colorScheme == .light ? Color.black.opacity(0.1) : Color(uiColor: UIColor.systemGray6)) : Color.red)
            .cornerRadius(10)
            .overlay {
                if error != nil && type == .username {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red.opacity(0.4), lineWidth: 2)
                }
            }
    }
}

enum TextFieldType {
    case serverURL, username
}

struct LoginButtonStyle: ButtonStyle {
    var loginDisabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width: 500, height: 50)
            .background(loginDisabled ? Color.gray : Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ShakeEffect: GeometryEffect {
    var position: CGFloat = 10
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    init(animatableData: CGFloat) {
       position = animatableData
   }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: -5 * sin(position * 2 * .pi), y: 0))
    }
}
