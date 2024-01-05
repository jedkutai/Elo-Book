//
//  PostCellExpandedTextBox.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct PostCellExpandedTextBox: View {
    @Binding var user: User
    @Binding var post: Post
    @Binding var likes: [PostLike]
    @Binding var comments: [Comment]
    @Binding var posting: Bool
    @Binding var caption: String
    @ObservedObject var viewModel: UploadComment
    
    var body: some View {
        HStack {
            
            TextField("Comment", text: $caption, axis: .vertical)
                .autocapitalization(.none)
                .font(.footnote)
                
            
            Spacer()
            if posting {
                ProgressView()
            }
            
            Group {
                if Checks.isValidCaption(caption) || (caption.isEmpty && viewModel.postImage != nil) {
                    Button {
                        posting.toggle()
                        hideKeyboard()
                        Task {
                            try await viewModel.uploadComment(user: user, post: post, caption: caption)
                            posting.toggle()
                            
                            caption = ""
                            viewModel.selectedImage = nil
                            viewModel.postImage = nil
                            
                            likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                            comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                        }
                        
                        
                    } label: {
                        Text("Post")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemBlue))
                    }
                } else {
                    Text("Post")
                        .font(.footnote)
                        .foregroundStyle(Color(.systemRed))
                }
            }
            .padding(.horizontal, 5)
        
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
    }
}
