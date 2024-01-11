//
//  PostCellExpandedFooter.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct PostCellExpandedFooter: View {
    @Binding var user: User
    @Binding var post: Post
    @Binding var comments: [Comment]
    @Binding var likes: [PostLike]
    @Binding var commentCount: Int
    @Environment(\.colorScheme) var colorScheme
    @State private var shareLink = ""
    @State private var likeCoolDown = false
    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            Button {
                if !likeCoolDown {
                    likeCoolDown = true
                    Task {
                        if likes.contains(where: { $0.userId == user.id }) { // already liked so unlike
                            try await PostService.unlikePost(postId: post.id, userId: user.id)
                            if let indexToRemove = likes.firstIndex(where: {$0.userId == user.id}) {
                                likes.remove(at: indexToRemove)
                            }
                        } else {
                            try await PostService.likePost(postId: post.id, userId: user.id)
                            likes.append(PostLike(id: "", postId: post.id, userId: user.id))
                        }
                        likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                        likeCoolDown = false
                    }
                }

            } label: {
                HStack {
                    if likes.contains(where: { $0.userId == user.id }) { // if post is liked
                        Image(systemName: "square.stack.3d.up.fill")
                            .foregroundColor(Theme.buttonColorInteracted)
                            
                    } else {
                        Image(systemName: "square.stack.3d.up")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                            
                        
                    }
                    
                    Text("\(likes.count)") // post likes
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                }
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "bubble")
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                
                Text("\(commentCount)")
                    .font(.footnote)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            }
            Spacer()
            
            if !shareLink.isEmpty {
                ShareLink(item: shareLink) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
            } else {
                Button {
                    shareLink = DeepLink.createPostLink(post: post)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
            }
            
            Spacer()
            
            Text(DateFormatter.shortDate(timestamp: post.timestamp))
                .font(.footnote)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.top, 5)
        .padding(.horizontal, 8.0)
        .onAppear {
            shareLink = DeepLink.createPostLink(post: post)
        }
    }
}
