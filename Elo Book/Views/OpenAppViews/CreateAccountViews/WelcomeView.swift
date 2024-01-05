//
//  WelcomeView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var user: User
    @Binding var userId: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(colorScheme == .dark ? Theme.blackLogoString : Theme.whiteLogoString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                
                if let username = user.username {
                    Text("@\(username)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
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
                    ProgressView()
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
