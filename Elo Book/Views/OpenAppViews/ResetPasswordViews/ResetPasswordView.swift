//
//  ResetPasswordView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/15/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var showExitScreen = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
//                HStack {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
//                    }
//                    .padding(.horizontal)
//                    
//                    Spacer()
//                }
                
                Spacer()
                
                Text("Enter your email:")
                    .foregroundStyle(Color(.systemGray))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 15)
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .modifier(IGTextFieldModifier())
                    .padding(.bottom, 15)
                
                if Checks.isValidEmail(email) {
                    Button {
                        showExitScreen.toggle()
                        let submission = email
                        email = ""
                        Task {
                            try await AuthService.resetPassword(withEmail: submission)
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
                        .background(Color(.systemGray))
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showExitScreen) {
                ResestPasswordExitCover()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    ResetPasswordView()
}
