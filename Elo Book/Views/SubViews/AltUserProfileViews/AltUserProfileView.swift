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
    
    @EnvironmentObject var x: X
    @State private var userProfilePosts: [Post] = []
    
    @State private var loadingMorePosts = false
    @State private var showMore = false
    @State private var blockAlert = false
    @State private var blockedUser = false
    @State private var blockedByUser = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if blockedByUser {
                
               Text("Failed to load page.")
                    .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
            } else {
                VStack {
                    if blockedUser {
                        Text("You must unblock this user to view their page.")
                             .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                             .padding(.horizontal)
                             .multilineTextAlignment(.center)
                        
                        Button {
                            Task {
                                try await UserService.unblockUser(user: user, userToUnBlock: viewedUser)
                                
                                x.blocked = try await FetchService.fectchBlocksViaUserId(userId: user.id)
                                
                                self.localRefresh()
                            }
                        } label: {
                            Text("Unblock")
                                .foregroundStyle(Color(.systemRed))
                        }
                    } else {
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
                            
                            self.localRefresh()
                        }
                        .onAppear {
                            let blockedByUser = x.blockedBy.contains { block in
                                return block.userId == viewedUser.id
                            }
                            
                            
                            if blockedByUser {
                                self.blockedByUser = true
                            } else {
                                
                                let blockedUser = x.blocked.contains { block in
                                    return block.userToBlockId == viewedUser.id
                                }
                                
                                self.blockedUser = blockedUser
                                Task {
                                    userProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: viewedUser.id)
                                }
                            }
                        }

                        
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if showMore {
                            Button {
                                blockAlert.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "circle.slash")
                                    Text("Block User")
                                }
                                .foregroundStyle(Color(.systemRed))
                                    
                            }
                        } else {
                            Button {
                                showMore.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                            }
                        }
                        
                    }
                    
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
                .onChange(of: showMore) {
                    if showMore {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showMore = false
                        }
                    }
                }
            }
            
        }
        .padding(.vertical, 1)
        .alert(isPresented: $blockAlert) {
            Alert(
                title: Text("Block User"),
                message: Text("Are you sure that you want to block this user?"),
                primaryButton: .destructive(Text("Block")) {
                    // block user
                    Task {
                        try await UserService.blockUser(user: user, userToBlock: viewedUser)
                        
                        x.blocked = try await FetchService.fectchBlocksViaUserId(userId: user.id)
                        
                        self.localRefresh()
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )

        }
    }
    
    private func localRefresh() {
        let blockedByUser = x.blockedBy.contains { block in
            return block.userId == viewedUser.id
        }
        
        if blockedByUser {
            self.blockedByUser = true
        } else {
            
            let blockedUser = x.blocked.contains { block in
                return block.userToBlockId == viewedUser.id
            }
            
            self.blockedUser = blockedUser
            
            
            Task {
                user = try await FetchService.fetchUserById(withUid: user.id)
                viewedUser = try await FetchService.fetchUserById(withUid: viewedUser.id)
                let newUserProfilePosts = try await FetchService.fetchUserProfilePostsByUserId(uid: viewedUser.id)
                userProfilePosts = []
                userProfilePosts = newUserProfilePosts
            }
        }
    }
}

