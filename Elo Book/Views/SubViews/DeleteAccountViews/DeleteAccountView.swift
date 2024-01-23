//
//  DeleteAccountView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/23/24.
//

import SwiftUI

private enum AccountDeletionStage {
    case firstStage
    case secondStage
    case thirdStage
    case finalStage
}

struct DeleteAccountView: View {
    @State var user: User
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var canSubmit = false
    @State private var invalidCredentials = false
    @State private var tooManyAttempts = false
    @State private var submitCooldown = false
    @State private var presentCover = false
    @State private var accountDeletionStage: AccountDeletionStage = .firstStage
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            switch accountDeletionStage {
            case .firstStage:
                firstStage
            case .secondStage:
                secondStage
            case .thirdStage:
                thirdStage
            case .finalStage:
                finalStage
            }
        }
        .padding()
        .fullScreenCover(isPresented: $presentCover) {
            goodbyeScreen
        }
    }
    
    var goodbyeScreen: some View {
        VStack {
            Spacer()
            
            Text("Close the app before this jumpscare happens.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            Spacer()
        }
    }
    
    var firstStage: some View {
        VStack {
            Spacer()
            
            Text("You hate the app so much you're willing to fill out a contact form????")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            
            Button {
                accountDeletionStage = .secondStage
            } label: {
                Text("Yes")
                    .foregroundStyle(Color(.systemBlue))
                    .padding(.top)
            }
            Spacer()
        }
    }
    
    var secondStage: some View {
        VStack {
            Spacer()
            
            Text("What if I told you I won't be able to afford rent if you delete your account?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            
            Button {
                accountDeletionStage = .thirdStage
            } label: {
                Text("Good")
                    .foregroundStyle(Color(.systemBlue))
                    .padding(.top)
            }
            
            Spacer()
        }
    }
    
    
    var thirdStage: some View {
        VStack {
            Spacer()
            
            Text("Okay I lied. I really want to buy a 992 GT3RS so I can drive it 25 mph in stop and go traffic.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            
            Button {
                accountDeletionStage = .finalStage
            } label: {
                Text("Walk")
                    .foregroundStyle(Color(.systemBlue))
                    .padding(.top)
            }
            
            Spacer()
        }
    }
    
    var finalStage: some View {
        VStack {
            Spacer()
            
            if invalidCredentials {
                Text("Invalid credentials, I think this is a sign to stay")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(.systemRed))
            } else {
                Text("We are sorry to see you go.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            }
            
            
            Text("Enter your email and passowrd to confirm deletion.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(.systemGray))
                .padding(.top)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .modifier(IGTextFieldModifier())
                .padding(.top)
            
            
            if showPassword {
                TextField("Password", text: $password)
                    .textContentType(.password)
                    .modifier(IGTextFieldModifier())
                    .padding(.top)
            } else {
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .modifier(IGTextFieldModifier())
                    .padding(.top)
            }
            
            Button {
                showPassword.toggle()
            } label: {
                Text(showPassword ? "Hide Password" : "Show Password")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
            }
            
            if canSubmit && !submitCooldown {
                Button {
                    canSubmit = false
                    submitCooldown = true
                    Task {
                        let passwordSubmission = password
                        let emailSubmission = email
                        password = ""
                        email = ""
                        let userId = try await AuthService.login(withEmail: emailSubmission, password: passwordSubmission)
                        if userId == user.id {
                            // valid deletion
                            Task {
                                try await AuthService.deleteAccount(withEmail: emailSubmission, password: passwordSubmission)
                                presentCover = true
                            }
                        } else {
                            invalidCredentials = true
                        }
                        
                    }
                } label: {
                    Text("Delete")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 44)
                        .background(Color(.systemRed))
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
            } else {
                Text("Delete")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 44)
                    .background(Color(.systemGray4))
                    .cornerRadius(8)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .onChange(of: password) {
            if !password.isEmpty && Checks.isValidEmail(email) {
                if email == user.email {
                    canSubmit = true
                    invalidCredentials = false
                }
            }
        }
        .onChange(of: submitCooldown) {
            if submitCooldown {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    submitCooldown = false
                }
            }
        }
        
    }
}

