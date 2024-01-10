//
//  UserProfileView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct UserProfileView: View {
    @Binding var user: User
    @Binding var refresh: Bool
    
    @State private var userProfilePosts: [Post] = []
    
    @State private var loadingMorePosts = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        HStack {
                            Spacer()
                            
                            if let username = user.username {
                                Text("\(username)")
                                    .fontWeight(.bold)
                            }
                            
                            if let badge = user.displayedBadge {
                                BadgeDiplayer(badge: badge)
                            }
                            
                            
                            Spacer()
                            
                            NavigationLink {
                                SettingsView(user: user, refresh: $refresh).navigationBarBackButtonHidden()
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                            }
                            
                            
                        }
                        .padding(.horizontal)
                        
                        ProfileHeader(user: $user)
                        
                        
                        ForEach(userProfilePosts, id: \.id) { (post) in
                            PostCell(user: user, post: post, postUser: user)
                        }
                        
                        if userProfilePosts.count >= 20 {
                            Button {
                                if !loadingMorePosts {
                                    loadingMorePosts.toggle()
                                    Task {
                                        let newPosts = try await FetchService.fetchMoreUserProfilePostsByUserId(uid: user.id, lastPost: userProfilePosts.last)
                                        userProfilePosts += newPosts
                                        loadingMorePosts.toggle()
                                    }
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    
                                    if loadingMorePosts {
                                        ProgressView()
                                    } else {
                                        Text("Load more")
                                            .font(.footnote)
                                            .foregroundStyle(Color(.gray).opacity(0.3))
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    userProfilePosts = []
                    Task {
                        user = try await FetchService.fetchUserById(withUid: user.id)
                        userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: user.id)
                    }
                }
                .onAppear {
                    
                    Task {
                        userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: user.id)
                    }
                }
                
                
                Spacer()
            }
            
        }
        .padding(.vertical, 1)
    }
}
