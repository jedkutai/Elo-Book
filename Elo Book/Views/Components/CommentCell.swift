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
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @State private var likes: [CommentLike] = []
    @State private var replies: Int?
    @State private var likeCooldown = false
    @State private var showMore = false
    @State private var commentDeleted = false
    @State private var showMoreText = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if commentDeleted || self.hidden {
            
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
                                    AltUserProfileView(user: user, viewedUser: commentUser)
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
                                        
                                        if let badge = commentUser.displayedBadge {
                                            BadgeDisplayer(badge: badge)
                                        }
                                    }
                                }
                                
                                

                                
                                if showMore {
                                    if user.id == commentUser.id {
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
                                        NavigationLink {
                                            ReportCommentView(user: user, commentUser: commentUser, comment: comment)
                                        } label: {
                                            Label("Report", systemImage: "exclamationmark.triangle.fill")
                                                .font(.footnote)
                                                .foregroundStyle(Color(.orange))
                                        }
                                    }
                                    
                                } else {
                                    Button {
                                        showMore.toggle()
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                    }
                                }
                                
                                
                                Spacer()
                            }
                            
                            if let caption = comment.caption {
                                if showMoreText {
                                    Text(caption)
                                        .font(.subheadline)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        .multilineTextAlignment(.leading)
                                    
                                } else {
                                    if caption.count <= 100 {
                                        HStack {
                                            Text(caption)
                                                .font(.subheadline)
                                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                    } else {
                                        
                                        Button {
                                            showMoreText.toggle()
                                        } label: {
                                            Group {
                                                Text("\(String(caption.prefix(75)))")
                                                    .font(.subheadline)
                                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                                
                                                + Text("...Show more.")
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color(.systemBlue))
                                            }
                                            .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        
                        
                        
                        VStack {
                            Text(DateFormatter.shortDate(timestamp: comment.timestamp))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Button {
                                if !likeCooldown {
                                    likeCooldown = true
                                    Task {
                                        if likes.contains(where: { $0.userId == user.id }) {
                                            try await CommentService.unlikeComment(comment: comment, userId: user.id)
                                            
                                        } else {
                                            try await CommentService.likeComment(comment: comment, userId: user.id)
                                        }
                                        likes = try await FetchService.fetchCommentLikesByCommentId(comment: comment)
                                        likeCooldown = false
                                    }
                                    
                                }
                            } label: {
                                HStack {
                                    if likes.contains(where: { $0.userId == user.id }) {
                                        Image(systemName: "square.stack.3d.up.fill")
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
                    
                    if let replies = replies {
                        if replies > 0 {
                            HStack {
                                Rectangle()
                                    .frame(width: 50, height: 1)
                                    .foregroundStyle(Color(.systemGray))
                                
                                Text("Replies: \(replies)")
                                    .font(.footnote)
                                    .foregroundStyle(Color(.systemGray))
                                
                                Rectangle()
                                    .frame(width: 50, height: 1)
                                    .foregroundStyle(Color(.systemGray))
                            }
                        } else {
                            HStack {
                                Rectangle()
                                    .frame(width: 50, height: 1)
                                    .foregroundStyle(Color(.systemGray))
                                
                                Text("Reply")
                                    .font(.footnote)
                                    .foregroundStyle(Color(.systemGray))
                                
                                Rectangle()
                                    .frame(width: 50, height: 1)
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                    } else {
                        HStack {
                            Rectangle()
                                .frame(width: 50, height: 1)
                                .foregroundStyle(Color(.systemGray))
                            
                            Text("Reply")
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray))
                            
                            Rectangle()
                                .frame(width: 50, height: 1)
                                .foregroundStyle(Color(.systemGray))
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 18)
            }
        }
        .onChange(of: showMore) {
            if showMore {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showMore = false
                }
            }
        }
        .onAppear {
            let blockedByUser = x.blockedBy.contains { block in
                return block.userId == comment.userId
            }
            
            let blockedUser = x.blocked.contains { block in
                return block.userToBlockId == comment.userId
            }
            
            self.hidden = blockedByUser || blockedUser
            
            Task {
                commentUser  = try await FetchService.fetchUserById(withUid: comment.userId)
                likes = try await FetchService.fetchCommentLikesByCommentId(comment: comment)
                do {
                    replies = try await FetchService.fetchCommentRepliesCountByCommentId(comment: comment)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
}
