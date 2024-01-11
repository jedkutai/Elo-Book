//
//  StaticPostCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher

struct StaticPostCell: View {
    @State var user: User
    @State var postUser: User
    @State var post: Post
    
    @State private var likes: [PostLike] = []
    @State private var comments: [Comment] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                StaticPostCellHeader(postUser: $postUser, post: $post)
                
                StaticPostCellBody(post: $post)
                
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.gray).opacity(0.15))
            )
            .onAppear {
                Task {
                    likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                    comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                }
            }
        }
    }
}
