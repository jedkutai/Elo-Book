//
//  SharedPostGroupMessageBubble.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct SharedPostGroupMessageBubble: View {
    @Binding var message: Message
    @Binding var messageUser: User
    @Binding var user: User
    @Binding var messageSetting: GroupMessageSettings
    @State private var post: Post?
    @State private var postUser: User?
    
    var body: some View {
        
        VStack {
            if let loadedPost = post, let loadedPostUser = postUser {
                if user.id == messageUser.id {
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink {
                                AltPostCellExpanded(user: user, postUser: loadedPostUser, post: loadedPost).navigationBarBackButtonHidden()
                            } label: {
                                StaticPostCellBlue(user: user, postUser: loadedPostUser, post: loadedPost)
                            }
                        }
                        
                        if !message.caption.isEmpty {
                            HStack {
                                Spacer()
                                Text("\(message.caption)")
                                    .foregroundStyle(Color(.white))
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(Color(.systemBlue))
                                    )
                            }
                        }
                        
                    }
                    
                } else {
                    HStack {
                        VStack {
                            Spacer()
                            if messageSetting.showProfileImage {
                                SquareProfilePicture(user: messageUser, size: .xSmall)
                            }
                        }
                        .frame(width: 22)
                        
                        VStack {
                            if messageSetting.showUsername {
                                HStack {
                                    if let username = messageUser.username {
                                        Text("\(username)")
                                            .font(.footnote)
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                    
                                    if let displayedBadge = messageUser.displayedBadge {
                                        BadgeDiplayer(badge: displayedBadge)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading)
                                
                            }
                            
                            HStack {
                                NavigationLink {
                                    AltPostCellExpanded(user: user, postUser: loadedPostUser, post: loadedPost).navigationBarBackButtonHidden()
                                } label: {
                                    StaticPostCell(user: user, postUser: loadedPostUser, post: loadedPost)
                                }
                                Spacer()
                            }
                            
                            if !message.caption.isEmpty {
                                HStack {
                                    Text("\(message.caption)")
                                        .foregroundStyle(Color(.black))
                                        .padding(5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(Color(.lightGray))
                                        )
                                    Spacer()
                                }
                                .padding(0)
                            }
                        }
                    }
                }
                
            }
            
        }
        .onAppear {
            Task {
                post = try await FetchService.fetchPostByPostId(postId: message.shareId)
                if let loadedPost = post {
                    postUser = try await FetchService.fetchUserById(withUid: loadedPost.userId)
                }
            }
        }
    }
}
