//
//  ProfileHeader.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct ProfileHeader: View {
    @Binding var user: User
    
    @State private var followingCount: Int?
    @State private var followersCount: Int?
    @State private var userProfilePosts: [Post] = []
    
    @State private var reloading = false
    @State private var editProfile = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if reloading {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    } else {
                        Button {
                            editProfile = true
                        } label: {
                            SquareProfilePicture(user: user, size: .large)
                        }
                        
                    }
                    
                    VStack {
                        HStack {
                            if let fullname = user.fullname {
                                Text("\(fullname)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                Spacer()
                            }
                        }

                        
                        HStack {
                            VStack {
                                
                                HStack{
                                    Text(userProfilePosts.count < 20 ? "Posts: \(userProfilePosts.count)" : "Posts: who cares")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }
                                
                                
                                HStack {
                                    Text("Following: \(followingCount ?? 0)")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Followers: \(followersCount ?? 0)")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }

                            }
                            
                            
                            Spacer()
                        }
                            
                    }
                    .padding(.horizontal, 4)
                    
                    
                    Spacer()
                }
                
                if let bio = user.bio {
                    HStack {
                        Text("\(bio)")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        Spacer()
                    }
                }
                
                Button {
                    editProfile = true
                } label: {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 32)
                        .background(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6)
                            .stroke(.gray, lineWidth: 1))
                }
                
                Divider()
                    .frame(height: 1)
            }
            .onAppear {
                Task {
                    followersCount = try await FetchService.fetchFollowersCount(userId: user.id)
                    followingCount = try await FetchService.fetchFollowingCount(userId: user.id)
                    userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: user.id)
                }
            }
            .padding(.horizontal)
            .fullScreenCover(isPresented: $editProfile) {
                EditProfileView(user: user, fullname: user.fullname ?? "", bio: user.bio ?? "")
                    .onDisappear {
                        editProfile = false
                        reloading.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            Task {
                                user = try await FetchService.fetchUserById(withUid: user.id)
                                reloading.toggle()
                            }
                        }
                        
                    }
            }
        }
    }
}
