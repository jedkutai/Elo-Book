//
//  FollowNotificationCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct FollowNotificationCell: View {
    @State var user: User
    @State var follow: Follow // new follwerId
    
    @State private var follower: User?
    @State private var failed = false
    @State private var followCooldown = false
    @State private var following = true
    @State private var yellow = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let follower = follower {
            NavigationStack {
                NavigationLink {
                    AltUserProfileView(user: user, viewedUser: follower)
                } label: {
                    VStack {
                        HStack {
                            HStack {
                                Text(DateFormatter.shortDate(timestamp: follow.timestamp))
                                    .font(.footnote)
                                    .foregroundStyle(Color(.systemGray))
                                    
                                Spacer()
                            }
                            .frame(width: 60)
                            
                            if let username = follower.username {
                                Text("\(username)")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            }
                            
                            if let displayedbadge = follower.displayedBadge {
                                BadgeDisplayer(badge: displayedbadge)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 10)
                                .foregroundStyle(Color(yellow ? .systemYellow : .clear))
                            
                            
                            if !following {
                                Button {
                                    if !followCooldown {
                                        followCooldown.toggle()
                                        Task {
                                            try await UserService.followUser(userId: user.id, userToFollowId: follower.id)
                                            following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: follower.id)
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
                            } else {
                                Button {
                                    if !followCooldown {
                                        followCooldown.toggle()
                                        Task {
                                            try await UserService.unFollowUser(userId: user.id, userToUnfollow: follower.id)
                                            following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: follower.id)
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
                            }
                            
                            
                            
                        }
                        .padding(.horizontal)
                        
                        Divider()
                    }
                    .onAppear {
                        if let notificationSeen = follow.notificationSeen {
                            if !notificationSeen {
                                yellow = true
                                Task {
                                    // update notification
                                    try await NotificationService.followAlertSeen(user: user, follow: follow)
                                    failed.toggle()
                                    failed.toggle()
                                }
                            }
                        } else {
                            yellow = true
                            Task {
                                // update notification
                                try await NotificationService.followAlertSeen(user: user, follow: follow)
                                failed.toggle()
                                failed.toggle()
                            }
                        }
                    }
                }
            }
        } else if failed {
            
        } else {
            Image(systemName: "circle")
                .foregroundStyle(Color(.clear))
                .onAppear {
                    Task {
                        do {
                            follower = try await FetchService.fetchUserById(withUid: follow.followerId)
                            if let follower = follower {
                                following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: follower.id)
                            } else {
                                failed = true
                            }
                        } catch {
                            failed = true
                        }
                    }
                }
        }
    }
}

