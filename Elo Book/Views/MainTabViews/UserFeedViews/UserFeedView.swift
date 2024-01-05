//
//  UserFeedView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct UserFeedView: View {
    @Binding var user: User
    @EnvironmentObject var x: X
    
    @State private var userFeedPosts: [Post] = []
    @State private var emptyUsers: [User] = []
    
    @State private var loadingMorePosts = false
    @State private var showCreatePostView = false
    @State private var showSuggestedUsers = false
    
    @State private var postCreated = false
    @Environment(\.colorScheme) var colorScheme
    private let emptyPadding = UIScreen.main.bounds.height / 4
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("elo")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .padding(.horizontal, 30)
                        
                        Spacer()
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(userFeedPosts, id: \.id) { post in
                                PostCell(user: user, post: post)
                                    .padding(.top, 1)
                            }
                            
                            if userFeedPosts.count >= 20 {
                                Button {
                                    if !loadingMorePosts {
                                        loadingMorePosts.toggle()
                                        loadMorePosts()
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
                            Text("Appear")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                            
                        }
                        
                        if showSuggestedUsers {
                            HStack {
                                Spacer()
                                Text("Accounts you might like:")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                Spacer()
                            }
                            .padding(.top, emptyPadding)
                            EmptyFeedView(user: user, emptyUsers: $emptyUsers)
                                
                        }
                        
                    }
                    .highPriorityGesture(DragGesture())
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showCreatePostView.toggle()
                        } label: {
                            Circle()
                                .fill(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "square.and.pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(.systemBlue))
                                        .frame(width: 38, height: 38)
                                )
                            
                        }
                    }
                    .padding(20)
                }
            }
            
            
        }
        .padding(.bottom, 1)
        .onAppear {
            if x.firstOpenUserFeed {
                localRefresh()
                x.firstOpenUserFeed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if userFeedPosts.isEmpty {
                    showSuggestedUsers = true
                }
            }
            
        }
        .fullScreenCover(isPresented: $x.loadedDeepLink) {
            if x.deepLinkType == "viewPost" {
                DeepLinkControllerView(deepLinkType: .post, deepLinkId: x.deepLinkId, user: user)
            } else if x.deepLinkType == "viewUser" {
                DeepLinkControllerView(deepLinkType: .user, deepLinkId: x.deepLinkId, user: user)
            }
        }
        .fullScreenCover(isPresented: $showCreatePostView) {
            CreatePostController(user: user, postCreated: $postCreated)
        }
        .refreshable {
            localRefresh()
        }
        .onChange(of: postCreated) {
            localRefresh()
        }
        .onChange(of: userFeedPosts) {
            showSuggestedUsers = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if userFeedPosts.isEmpty {
                    showSuggestedUsers = true
                }
            }
        }
        
    }
    
    private func localRefresh() {
        Task {
            userFeedPosts = try await FetchService.fetchFeedPostsByUser(user: user)
        }
    }
    
    private func loadMorePosts() {
        Task {
            userFeedPosts = try await FetchService.fetchMoreFeedPostsByUser(user: user, userFeedPosts: userFeedPosts)
            loadingMorePosts = false
        }
    }
}
