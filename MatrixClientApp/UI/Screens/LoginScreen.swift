//
//  LoginScreen.swift
//  MatrixClientApp
//
//  Created by Hassan Shahid on 22.11.2025.
//


import SwiftUI

import SwiftUI

struct LoginScreen: View {
    @ObservedObject var loginVM: LoginVM = LoginVM()
//    @State private var username = "a8ce971b"
//    @State private var password = "46c8b401"

    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case username, password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            Text("matrix_client_title".localized)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("matrix_client_description".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 30)
            
            VStack(spacing: 16) {
                TextField("username_title".localized, text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
                
                SecureField("password_title".localized, text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { loginVM.login(username: username, password: password) }
                
                if let error = loginVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    loginVM.login(username: username, password: password)
                    dismissKeyboard()
                }) {
                    if loginVM.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("login_button".localized)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(loginVM.isLoading || username.isEmpty || password.isEmpty)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .background(
            Color(.systemBackground)
                .onTapGesture { dismissKeyboard() }
        )
    }
    
    private func dismissKeyboard() {
        focusedField = nil
    }
}
