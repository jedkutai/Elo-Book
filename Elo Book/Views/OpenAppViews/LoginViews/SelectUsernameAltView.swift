//
//  SelectUsernameAltView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct SelectUsernameAltView: View {
    
    @Binding var userId: String
    @Binding var currentView: loginViewShown
    
    @State private var usernameAvailable: Bool = false
    @State private var username: String = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer()
                
                Text("Select Username")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .padding()
                
                Text("Minimum of 4 Characters")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .modifier(IGTextFieldModifier())
                    .padding(.bottom, 15)
                
                if usernameAvailable {
                    Button {
                        Task {
                            await AuthService.setUsername(uid: userId, username: username)
                            currentView = .welcomeUser
                        }
                    } label: {
                        Text("Continue")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 44)
                            .background(Color(.systemBlue))
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                } else {
                    Text("Continue")
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
            .onChange(of: username) {
                if Checks.isValidUsername(username) {
                    Task {
                        usernameAvailable = await Checks.isUsernameAvailable(username)
                    }
                } else {
                    usernameAvailable = false
                }
            }
        }
    }
}
