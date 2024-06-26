//
//  ExpandedPostCellFromCommentAlertFooter.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct ExpandedPostCellFromCommentAlertFooter: View {
    @Binding var user: User
    @State var post: Post
    @Binding var comments: [Comment]
    @Binding var likes: [PostLike]
    @Binding var commentCount: Int
    @Environment(\.colorScheme) var colorScheme
    @State private var likeCoolDown = false
    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            Button {
                if !likeCoolDown {
                    likeCoolDown = true
                    Task {
                        if likes.contains(where: { $0.userId == user.id }) { // already liked so unlike
                            try await PostService.unlikePost(post: post, user: user)
                            if let indexToRemove = likes.firstIndex(where: {$0.userId == user.id}) {
                                likes.remove(at: indexToRemove)
                            }
                        } else {
                            try await PostService.likePost(post: post, user: user)
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
            
            NavigationLink {
                SharePostView(user: user, postUser: user, postToShare: post)
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
            }
            
            Spacer()
            
            Text(DateFormatter.shortDate(timestamp: post.timestamp))
                .font(.footnote)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.top, 5)
        .padding(.horizontal, 8.0)
    }
}

