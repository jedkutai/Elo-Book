//
//  FollowsResultCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI

struct FollowsResultCell: View {
    @State var user: User
    @State var viewedUser: User
    
    @State private var followCooldown = false
    @State private var isFollowing = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            UserResultCell(user: viewedUser)
            
            if user.id != viewedUser.id {
                if isFollowing {
                    Button {
                        if !followCooldown {
                            followCooldown.toggle()
                            Task {
                                try await UserService.unFollowUser(userId: user.id, userToUnfollow: viewedUser.id)
                                isFollowing = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                                followCooldown.toggle()
                            }
                        }
                    } label: {
                        Text("Following")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .frame(height: 20)
                            .background(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(.gray, lineWidth: 1))
                    }
                } else {
                    Button {
                        if !followCooldown {
                            followCooldown.toggle()
                            Task {
                                try await UserService.followUser(userId: user.id, userToFollowId: viewedUser.id)
                                isFollowing = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                                followCooldown.toggle()
                            }
                        }
                    } label: {
                        Text("Follow")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .frame(height: 20)
                            .background(Color(.systemBlue))
                            .foregroundStyle(Color(.white))
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(.clear, lineWidth: 1))
                    }
                }
            }
        }
        .onAppear {
            Task {
                isFollowing = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
            }
        }
    }
}
