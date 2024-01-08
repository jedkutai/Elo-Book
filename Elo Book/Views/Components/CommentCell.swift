//
//  CommentCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct CommentCell: View {
    @State var user: User
    @State var comment: Comment
    @State private var commentUser: User?
    
    
    @State private var likes: [CommentLike] = []
    
    @State private var showDelete = false
    @State private var commentDeleted = false
    @State private var showMore = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if commentDeleted {
            
        } else {
            commentCell
        }
    }
    
    var commentCell: some View {
        NavigationStack {
            if let commentUser = commentUser {
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                NavigationLink {
                                    AltUserProfileView(user: user, viewedUser: commentUser).navigationBarBackButtonHidden()
                                } label: {
                                    HStack {
                                        SquareProfilePicture(user: commentUser, size: .xSmall)
                                        
                                        if let fullname = commentUser.fullname {
                                            Text(fullname)
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        }
                                        
                                        if let username = commentUser.username {
                                            Text(username)
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(.systemGray))
                                        }
                                    }
                                }
                                
                                
                                if user.id == commentUser.id {
                                    if showDelete {
                                        Button {
                                            Task {
                                                try await CommentService.deleteComment(comment: comment)
                                            }
                                            commentDeleted.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                                .font(.subheadline)
                                                .foregroundStyle(Color(.red))
                                        }
                                    } else {
                                        Button {
                                            showDelete.toggle()
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                        }
                                    }
                                }
                                
                                
                                Spacer()
                            }
                            
                            if showMore {
                                Text(comment.caption)
                                    .font(.subheadline)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    .multilineTextAlignment(.leading)
                                
                                Button {
                                    showMore.toggle()
                                } label: {
                                    Text("show less")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                
                            } else {
                                if comment.caption.count <= 100 {
                                    HStack {
                                        Text(comment.caption)
                                            .font(.subheadline)
                                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                } else {
                                    
                                    Button {
                                        showMore.toggle()
                                    } label: {
                                        Text("\(String(comment.caption.prefix(75)))... SHOW MORE")
                                            .font(.subheadline)
                                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            
                            
                        }
                        
                        
                        
                        VStack {
                            Text(DateFormatter.shortDate(timestamp: comment.timestamp))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Button {
                                Task {
                                    if likes.contains(where: { $0.userId == user.id }) {
                                        try await CommentService.unlikeComment(comment: comment, userId: user.id)
                                        
                                    } else {
                                        try await CommentService.likeComment(comment: comment, userId: user.id)
                                    }
                                    likes = try await FetchService.fetchCommentLikesByCommentId(comment: comment)
                                }
                            } label: {
                                HStack {
                                    if likes.contains(where: { $0.userId == user.id }) {
                                        Image(systemName: "square.stack.3d.up")
                                            .foregroundColor(Theme.buttonColorInteracted)
                                    } else {
                                        Image(systemName: "square.stack.3d.up")
                                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                    }
                                    
                                    Text("\(likes.count)")
                                        .font(.subheadline)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                }
                                
                                    
                            }
                        }
                        
                    }
                    Divider()
                        .frame(height: 1)
                }
                .padding(.horizontal, 18)
            }
        }
        .onAppear {
            Task {
                commentUser  = try await FetchService.fetchUserById(withUid: comment.userId)
                likes = try await FetchService.fetchCommentLikesByCommentId(comment: comment)
            }
        }
    }
    
}
