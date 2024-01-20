//
//  AltProfileHeader.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct AltProfileHeader: View {
    @Binding var user: User
    @Binding var viewedUser: User
//    @Binding var shareProfile: Bool
    @State private var followingCount: Int?
    @State private var followersCount: Int?
    @State private var postCount: Int?
    @State private var userProfilePosts: [Post] = []
    
    @State private var reloading = false
    @State private var followCooldown = false
    @State private var editProfile = false
    @State private var following = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if reloading {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    } else {
                        SquareProfilePicture(user: viewedUser, size: .large)
                    }
                    
                    VStack {
                        HStack {
                            if let fullname = viewedUser.fullname {
                                Text("\(fullname)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                Spacer()
                            }
                        }

                        
                        HStack {
                            VStack {
                                
                                HStack{
                                    Text("Posts: \(postCount ?? 0)")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }
                                
                                
                                NavigationLink {
                                    FollowingView(user: user, viewedUser: viewedUser)
                                } label: {
                                    HStack {
                                        Text("Following: \(followingCount ?? 0)")
                                            .font(.footnote)
                                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        
                                        Spacer()
                                    }
                                }
                                
                                NavigationLink {
                                    FollowersView(user: user, viewedUser: viewedUser)
                                } label: {
                                    HStack {
                                        Text("Followers: \(followersCount ?? 0)")
                                            .font(.footnote)
                                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        
                                        Spacer()
                                    }
                                }

                            }
                            
                            
                            Spacer()
                        }
                            
                    }
                    .padding(.horizontal, 4)
                    
                    
                    Spacer()
                    
//                    Button {
//                        shareProfile.toggle()
//                    } label: {
//                        Image(systemName: "square.and.arrow.up")
//                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
//                    }
                    NavigationLink {
                        ShareProfileView(user: user, userToShare: viewedUser)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                }
                
                if let bio = viewedUser.bio {
                    HStack {
                        Text("\(bio)")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        Spacer()
                    }
                }
                
                if user.id != viewedUser.id {
                    if following {
                        Button {
                            if !followCooldown {
                                followCooldown.toggle()
                                Task {
                                    try await UserService.unFollowUser(userId: user.id, userToUnfollow: viewedUser.id)
                                    following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                                    followersCount = try await FetchService.fetchFollowersCount(userId: viewedUser.id)
                                    followingCount = try await FetchService.fetchFollowingCount(userId: viewedUser.id)
                                    followCooldown.toggle()
                                }
                            }
                        } label: {
                            Text("Following")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 360, height: 32)
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
                                    following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                                    followersCount = try await FetchService.fetchFollowersCount(userId: viewedUser.id)
                                    followingCount = try await FetchService.fetchFollowingCount(userId: viewedUser.id)
                                    followCooldown.toggle()
                                }
                            }
                        } label: {
                            Text("Follow")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 360, height: 32)
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
                    following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                    followersCount = try await FetchService.fetchFollowersCount(userId: viewedUser.id)
                    followingCount = try await FetchService.fetchFollowingCount(userId: viewedUser.id)
                    postCount = try await FetchService.fetchPostCount(userId: viewedUser.id)
                    userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: viewedUser.id)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }
}
