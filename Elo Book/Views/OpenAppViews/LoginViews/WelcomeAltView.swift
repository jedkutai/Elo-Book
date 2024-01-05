//
//  WelcomeAltView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct WelcomeAltView: View {
    @Binding var userId: String
    @Binding var currentView: loginViewShown
    @Binding var user: User
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(colorScheme == .dark ? Theme.blackLogoString : Theme.whiteLogoString)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 140)
                
                if user.email.isEmpty {
                    ProgressView()
    
                } else {
                    if let username = user.username {
                        Text("Welcome back, \(username)!")
                            .font(.title2)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .fontWeight(.bold)
                            .padding()
                        
                        NavigationLink {
                            MainTabControllerView(user: user).navigationBarBackButtonHidden()
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
                        Text("You never chose a username after creating your account. Click below to finish setup!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button {
                            user = User.MOCK_USER
                            currentView = .selectUsername
                        } label: {
                            Text("Finish Setup")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 360, height: 44)
                                .background(Color(.systemBlue))
                                .cornerRadius(8)
                                .padding(.top, 20)
                        }
                    }
                    
                }
                Spacer()
            }
            .onAppear {
                Task {
                    user = try await FetchService.fetchUserById(withUid: userId)
                }
            }
        }
    }
}
