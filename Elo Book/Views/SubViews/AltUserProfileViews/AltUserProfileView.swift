//
//  AltUserProfileView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct AltUserProfileView: View {
    @State var user: User
    @State var viewedUser: User
    
    @State private var userProfilePosts: [Post] = []
    
    @State private var loadingMorePosts = false
    @State private var shareLink = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                            }
                            Spacer()
                            
                            if let username = viewedUser.username {
                                Text("\(username)")
                                    .fontWeight(.bold)
                            }
                            
                            
                            Spacer()
                            
                            if !shareLink.isEmpty {
                                ShareLink(item: shareLink) {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: Dimensions.buttonHeight)
                                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            } else {
                                Button {
                                    shareLink = DeepLink.createUserProfileLink(user: viewedUser)
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: Dimensions.buttonHeight)
                                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                            
                            
                        }
                        .padding(.horizontal)
                        
                        AltProfileHeader(user: $user, viewedUser: $viewedUser)
                        
                        
                        ForEach(userProfilePosts, id: \.id) { (post) in
                            PostCell(user: user, post: post, postUser: viewedUser)
                        }
                        
                        if !userProfilePosts.isEmpty {
                            Button {
                                if !loadingMorePosts {
                                    loadingMorePosts.toggle()
                                    Task {
                                        let newPosts = try await FetchService.fetchMoreUserProfilePostsByUserId(uid: viewedUser.id, lastPost: userProfilePosts.last)
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
                        viewedUser = try await FetchService.fetchUserById(withUid: viewedUser.id)
                        userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: viewedUser.id)
                    }
                }
                .onAppear {
                    shareLink = DeepLink.createUserProfileLink(user: viewedUser)
                    Task {
                        userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: viewedUser.id)
                    }
                }

                
                Spacer()
            }
            
        }
        .padding(.vertical, 1)
    }
}

#Preview {
    AltUserProfileView(user: User.MOCK_USER, viewedUser: User.MOCK_USER)
}
