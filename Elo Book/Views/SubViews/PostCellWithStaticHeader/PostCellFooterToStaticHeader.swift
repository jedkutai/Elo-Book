//
//  PostCellFooterToStaticHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/18/24.
//

import SwiftUI

struct PostCellFooterToStaticHeader: View {
    @Binding var user: User
    @State var postUser: User
    @Binding var post: Post
    @Binding var likes: [PostLike]
    @Binding var comments: [Comment]
    @Binding var commentCount: Int
    @Binding var postDeleted: Bool
    @Binding var showMore: Bool
    
    @State private var shareLink = ""
    @State private var likeCoolDown = false
    @State private var sharePost = false
    @Environment(\.colorScheme) var colorScheme
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
            
            NavigationLink {
                ExpandedPostCellWithStaticHeader(user: user, postUser: postUser, post: post, comments: $comments, likes: $likes, commentCount: $commentCount, postDeleted: $postDeleted, showMore: $showMore)
                
            } label: {
                HStack {
                    Image(systemName: "bubble")
                        .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    
                    Text("\(commentCount)")
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                }
            }
            Spacer()

            
            Button {
                sharePost.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
            }
            
            Spacer()
            
            
            Text(DateFormatter.shortDate(timestamp: post.timestamp))
                .font(.footnote)
                .foregroundColor(.gray)
            
            
        }
        .padding(.top, 5)
        .padding(.horizontal, 8.0)
        .fullScreenCover(isPresented: $sharePost) {
            SharePostView(user: user, postUser: postUser, postToShare: post)
        }
    }
}

