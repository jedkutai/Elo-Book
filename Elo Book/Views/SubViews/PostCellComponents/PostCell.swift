//
//  PostCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI
import Kingfisher

struct PostCell: View {
    @State var user: User
    @State var post: Post
    @State var postUser: User?
    
    @State private var likes: [PostLike] = []
    @State private var comments: [Comment] = []
    
    @State private var expandPost = false
    @State private var postDeleted = false
    @State private var showMore = false
    
    @Environment(\.colorScheme) var colorScheme
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    var body: some View {
        if postDeleted {
            
        } else {
            postCell
        }
    }
    
    var postCell: some View {
        NavigationStack {
            if let postUser = postUser {
                VStack {
                    PostCellHeader(user: $user, postUser: postUser, post: $post, showMore: $showMore, postDeleted: $postDeleted)
                    
                    PostCellBody(post: $post, expandPost: $expandPost)
                    
                    PostCellFooter(user: $user, post: $post, likes: $likes, comments: $comments, expandPost: $expandPost)
                }
                .fullScreenCover(isPresented: $expandPost) {
                    ExpandedPostCell(user: user, postUser: postUser, post: post, comments: $comments, likes: $likes)
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
            Task {
                postUser = try await FetchService.fetchUserById(withUid: post.userId)
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

#Preview {
    PostCell(user: User.MOCK_USER, post: Post.MOCK_POST)
}
