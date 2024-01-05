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
    @Environment(\.colorScheme) var colorScheme
    @State private var shareLink = ""
    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            Button {
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
                }

            } label: {
                HStack {
                    if likes.contains(where: { $0.userId == user.id }) { // if post is liked
                        Image(systemName: "square.stack.3d.up.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: Dimensions.buttonHeight)
                            .foregroundColor(Theme.buttonColorInteracted)
                            
                    } else {
                        Image(systemName: "square.stack.3d.up")
                            .resizable()
                            .scaledToFit()
                            .frame(height: Dimensions.buttonHeight)
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
                    .resizable()
                    .scaledToFit()
                    .frame(height: Dimensions.buttonHeight)
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    
            }
            Spacer()
            
            if !shareLink.isEmpty {
                ShareLink(item: shareLink) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(height: Dimensions.buttonHeight)
                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
            } else {
                Button {
                    shareLink = DeepLink.createPostLink(post: post)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(height: Dimensions.buttonHeight)
                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
            }
            
            Spacer()
            
            Text(DateFormatter.shortDate(timestamp: post.timestamp))
                .font(.footnote)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.horizontal, 8.0)
        .onAppear {
            shareLink = DeepLink.createPostLink(post: post)
        }
    }
}
