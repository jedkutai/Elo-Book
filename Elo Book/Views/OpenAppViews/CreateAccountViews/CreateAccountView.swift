//
//  CreateAccountView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Binding var userId: String
    @Binding var viewShown: createAccountViewShown
    var dismiss: DismissAction
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var dateOfBirth = Date.now
    @State private var over18 = true
    @State private var attemptingCreation = false
    @State private var emailUnavailable = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                if !over18 {
                    Text("This isn't a day care.")
                        .foregroundStyle(Color(.red))
                }
                
                if emailUnavailable {
                    Text("Email is already in use.")
                        .foregroundStyle(Color(.red))
                }
                Spacer()
                
                Text("Create Account")
                    .font(.title2)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .fontWeight(.bold)
                    .padding()
                
                DatePicker(selection: $dateOfBirth, in: ...Date.now, displayedComponents: .date) {
                    Text("Enter Date of Birth:")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                }
                .padding(25)

                
                Text("You'll use this email to sign in to your account.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .modifier(IGTextFieldModifier())
                    .disableAutocorrection(true)
                    .padding(.bottom, 15)
                
                
                Text("Password must be at least 8 characters long.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .modifier(IGTextFieldModifier())
                
                SecureField("Confirm Password", text: $passwordConfirm)
                    .textContentType(.password)
                    .modifier(IGTextFieldModifier())
            
                
                
                if Checks.isValidSignUp(email, password, passwordConfirm) {
                    Button {
                        if Checks.isUserOver18(dateOfBirth) {
                            over18 = true
                            attemptingCreation = true
                            Task {
                                userId = try await AuthService.createAccount(email: email, password: password, dateOfBirth: dateOfBirth)
                                if userId == ErrorMessageStrings.emailInUse {
                                    emailUnavailable.toggle()
                                    userId = ""
                                } else {
                                    viewShown = .selectUsername
                                }
                                
                                attemptingCreation = false
                            }
                        } else {
                            over18 = false
                        }
                    } label: {
                        
                        Text("Create Account")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 44)
                            .background(Color(.systemBlue))
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                } else {
                    if attemptingCreation {
                        ProgressView()
                    } else {
                        Text("Create Account")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 44)
                            .background(Color(.systemGray4))
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                    
                }
                
                Spacer()
                Spacer()
                    
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: email) {
                emailUnavailable = false
            }
        }
    }
}

