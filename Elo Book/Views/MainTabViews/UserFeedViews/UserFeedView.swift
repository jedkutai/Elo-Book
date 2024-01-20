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
    @State private var emptyUsers: [User] = [] // for when userfeed is empty
    
    @State private var loadingMorePosts = false
    @State private var showCreatePostView = false
    @State private var showSuggestedUsers = false
    @State private var elementsLoaded: Bool = false
    
    @State private var postCreated = false
    @Namespace var namespace
    @Environment(\.colorScheme) var colorScheme
    private let emptyPadding = UIScreen.main.bounds.height / 4
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image(colorScheme == .dark ? "elo_white" : "elo_black")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                        
                        NavigationLink {
//                            Text("Under Construction")
//                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            NotificationView(user: $user)
                        } label: {
                            
                            VStack {
                                Spacer()
                                
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                
                                // if has notifications
//                                Image(systemName: "bell.fill")
//                                    .foregroundStyle(Color(.systemOrange))
                            }
                            .frame(height: 30)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            AddContactsView(user: $user).navigationBarBackButtonHidden()
                        } label: {
                            VStack {
                                Spacer()
                                
                                Image(systemName: "person.badge.plus")
                                    .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                            }
                            .frame(height: 30)
                            
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    if elementsLoaded {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack {
                                ForEach($userFeedPosts, id: \.id) { post in
                                    PostCell(user: $user, post: post)
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
                                    .foregroundStyle(Color(.clear))
                                
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
                    } else {
                        VStack {
                            Spacer()
                            ProgressView("Degenerating...")
                                .matchedGeometryEffect(id: "Degenerating", in: namespace)
                            Spacer()
                        }
                    }
                
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
                Task {
                    try await UserService.uploadFCMToken(user: user)
                }
                localRefresh()
                x.firstOpenUserFeed.toggle()
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
            CreatePostMasterView(user: user, postCreated: $postCreated)
        }
        .refreshable {
            userFeedPosts = []
            localRefresh()
        }
        .onChange(of: postCreated) {
            localRefresh()
        }
        .onChange(of: userFeedPosts) {
            showSuggestedUsers = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if userFeedPosts.isEmpty {
                    showSuggestedUsers = true
                }
            }
        }
        
    }
    
    private func localRefresh() {
        Task {
            user = try await FetchService.fetchUserById(withUid: user.id)
            userFeedPosts = try await FetchService.fetchFeedPostsByUser(user: user)
            if userFeedPosts.isEmpty {
                showSuggestedUsers = true
            }
            self.elementsLoaded = true // Set to true when elements are loaded
        }
    }
    
    private func loadMorePosts() {
        Task {
            user = try await FetchService.fetchUserById(withUid: user.id)
            userFeedPosts = try await FetchService.fetchMoreFeedPostsByUser(user: user, userFeedPosts: userFeedPosts)
            loadingMorePosts = false
        }
    }
}
