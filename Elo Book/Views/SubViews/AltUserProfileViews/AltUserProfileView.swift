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
    @State private var swipeStarted = false
//    @State private var shareProfile = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        
                        AltProfileHeader(user: $user, viewedUser: $viewedUser)
                        
                        Divider()
                            .frame(height: 1)
                        
                        ForEach($userProfilePosts, id: \.id) { (post) in
                            PostCellWithStaticHeader(user: $user, post: post, postUser: viewedUser)
                        }
                        
                        if userProfilePosts.count >= 20 {
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
                    Task {
                        userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: viewedUser.id)
                    }
                }

                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let username = viewedUser.username {
                        Text("\(username)")
                            .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .fontWeight(.bold)
                    }
                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    if let badge = viewedUser.displayedBadge {
                        BadgeDiplayer(badge: badge)
                    }
                }
            }
//            .fullScreenCover(isPresented: $shareProfile) {
//                ShareProfileView(user: user, userToShare: viewedUser)
//            }
            
        }
        .padding(.vertical, 1)
    }
}

#Preview {
    AltUserProfileView(user: User.MOCK_USER, viewedUser: User.MOCK_USER)
}
