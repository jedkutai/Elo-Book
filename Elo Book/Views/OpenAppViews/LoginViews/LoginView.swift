//
//  LoginView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct LoginView: View {
    @Binding var userId: String
    @Binding var currentView: loginViewShown
    var dismiss: DismissAction
    
    
    @State private var email = ""
    @State private var password = ""
    @State private var canSubmit = true
    @State private var invalidLogin = false
    @State private var tooManyAttempts = false
    @State private var showPassword = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(colorScheme == .dark ? Theme.blackLogoString : Theme.whiteLogoString)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 140)
                
                
                if invalidLogin {
                    Text("Invalid login.")
                        .foregroundStyle(Color(.red))
                }
                
                if tooManyAttempts {
                    Text("Too many attempts, try again later.")
                        .foregroundStyle(Color(.red))
                }
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .modifier(IGTextFieldModifier())
                    .padding(.bottom, 15)
                
                
                if showPassword {
                    TextField("Password", text: $password)
                        .textContentType(.password)
                        .modifier(IGTextFieldModifier())
                } else {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .modifier(IGTextFieldModifier())
                }
                
                
                
                HStack {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Text(showPassword ? "Hide" : "Show")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                    Spacer()
                    
                    NavigationLink {
                        ResetPasswordView().navigationBarBackButtonHidden()
                    } label: {
                        Text("Forgot password?")
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
                .padding(.horizontal, 27)
                
                if canSubmit {
                    Button {
                        canSubmit = false

                        Task {
                            userId = try await AuthService.login(withEmail: email, password: password)
                            if userId.hasPrefix("Error:") {
                                if userId == ErrorMessageStrings.genericErrorMessage || userId == ErrorMessageStrings.invalidPassword {
                                    canSubmit = true
                                    invalidLogin = true
                                } else if userId == ErrorMessageStrings.tooManyAttempts {
                                    tooManyAttempts = true
                                    invalidLogin = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 120.0) {
                                        tooManyAttempts = false
                                        canSubmit = true
                                    }
                                } else {
                                    canSubmit = true
                                    invalidLogin = true
                                }
                                
                            } else {
                                currentView = .welcomeUser
                            }
                            
                        }
                    } label: {
                        Text("Login")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 44)
                            .background(Color(.systemBlue))
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                } else {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemGray4))
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: email) {
                invalidLogin = false
            }
            .onChange(of: password) {
                invalidLogin = false
            }
    
        }
    }
}
