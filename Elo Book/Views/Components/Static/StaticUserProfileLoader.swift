//
//  StaticUserProfileLoader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/16/24.
//

import SwiftUI

struct StaticUserProfileLoader: View {
    @State var user: User
    @State var viewedUserId: String
    
    @State private var viewedUser: User?
    var body: some View {
        if let viewedUser = viewedUser {
            NavigationLink {
                AltUserProfileView(user: user, viewedUser: viewedUser)
            } label: {
                StaticUserProfile(user: user, userToShare: viewedUser)
            }
        } else {
            ProgressView("Loading Profile...")
                .onAppear {
                    Task {
                        viewedUser = try await FetchService.fetchUserById(withUid: viewedUserId)
                    }
                }
        }
    }
}

