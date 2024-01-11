//
//  SharedPostMessageBubble.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct SharedPostMessageBubble: View {
    @Binding var message: Message
    @Binding var messageUser: User
    @Binding var user: User
    
    @State private var post: Post?
    @State private var postUser: User?
    
    var body: some View {
        
        VStack {
            if let loadedPost = post, let loadedPostUser = postUser {
                NavigationLink {
                    AltPostCellExpanded(user: user, postUser: loadedPostUser, post: loadedPost).navigationBarBackButtonHidden()
                } label: {
                    if user.id == messageUser.id {
                        HStack {
                            Spacer()
                            StaticPostCellBlue(user: user, postUser: loadedPostUser, post: loadedPost)
                        }
                    } else {
                        HStack {
                            StaticPostCell(user: user, postUser: loadedPostUser, post: loadedPost)
                            Spacer()
                        }
                        
                    }
                }
                
            }
            if !message.caption.isEmpty {
                StandardMessageBubble(message: $message, messageUser: $messageUser, user: $user)
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
