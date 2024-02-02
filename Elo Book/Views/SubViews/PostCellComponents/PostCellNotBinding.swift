//
//  PostCellNotBinding.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/24/24.
//

import SwiftUI
import Kingfisher

struct PostCellNotBinding: View {
    @Binding var user: User // changed
    @State var post: Post // changed
    @State var postUser: User?
    
    @State private var likes: [PostLike] = []
    @State private var comments: [Comment] = []
    @State private var commentCount: Int = 0
    
    @State private var postDeleted = false
    @State private var showMore = false
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if postDeleted {
            Text("post deleted")
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                .italic()
                .padding(.horizontal)
        } else if hidden {
            Text("failed to load post")
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                .italic()
                .padding(.horizontal)
        } else {
            postCell
        }
    }
    
    var postCell: some View {
        NavigationStack {
            if let postUser = postUser {
                VStack {
                    PostCellHeader(user: $user, postUser: postUser, post: $post, showMore: $showMore, postDeleted: $postDeleted)
                    
                    PostCellBody2(user: user, viewedUser: postUser, post: post)
                    
                    PostCellFooter2(user: $user, postUser: postUser, post: $post, likes: $likes, comments: $comments, commentCount: $commentCount, postDeleted: $postDeleted, showMore: $showMore)
                }
                .padding(10)
                .frame(width: UIScreen.main.bounds.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.gray).opacity(0.5), lineWidth: 2)
                )
            }
            
        }
        .onAppear {
            let blockedByUser = x.blockedBy.contains { block in
                return block.userId == post.userId
            }
            
            let blockedUser = x.blocked.contains { block in
                return block.userToBlockId == post.userId
            }
            
            self.hidden = blockedByUser || blockedUser
            
            Task {
                postUser = try await FetchService.fetchUserById(withUid: post.userId)
                commentCount = try await FetchService.fetchCommentCountByPost(postId: post.id)
                likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                
            }
        }
        .onChange(of: showMore) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showMore = false
            }
        }
        
    }
}
