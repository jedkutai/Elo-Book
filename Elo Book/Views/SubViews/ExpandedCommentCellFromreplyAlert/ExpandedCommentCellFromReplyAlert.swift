//
//  ExpandedCommentCellFromReplyAlert.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/24/24.
//

import SwiftUI

struct ExpandedCommentCellFromReplyAlert: View {
    @State var user: User
    @State var replyAlert: ReplyOnCommentAlert
    @State var targetReply: Reply
    
    
    @State var comment: Comment?
    @State var post: Post?
    @State var postUser: User?
    @State private var replies: [Reply] = []
    @State private var likes: [ReplyLike] = []
    @State private var failed = false
    @State private var hidden = false
    @State private var posting = false
    @State private var showOriginalPost = false
    @State private var caption: String = ""
    
    @State private var showMore = false
    @State private var postDeleted = false
    @StateObject private var viewModel = UploadReply()
    @EnvironmentObject var x: X
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if let comment = comment, let post = post {
                VStack {
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        if showOriginalPost {
                            PostCellNotBinding(user: $user, post: post)
                        }
                        
                        Button {
                            showOriginalPost.toggle()
                        } label: {
                            Text(showOriginalPost ? "hide post" :  "show post")
                                .font(.footnote)
                                .foregroundStyle(Color(.systemBlue))
                                .padding(.horizontal)
                        }
                        
                        CommentCell(user: user, comment: comment)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color(.gray).opacity(0.15))
                            )
                            .padding(.top, 2)
                            .padding(.horizontal, 10)
                        
                        ForEach(replies, id: \.id) { reply in
                            if reply.id == targetReply.id {
                                ReplyCell(user: $user, reply: reply)
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 2.5)
                                            .stroke(Color(.systemYellow), lineWidth: 2)
                                    )
                                
                            } else {
                                VStack {
                                    ReplyCell(user: $user, reply: reply)
                                    
                                    Divider()
                                }
                            }
                        }
                        
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .refreshable {
                        Task {
                            let newReplies = try await FetchService.fetchCommentRepliesByCommentId(comment: comment)
                            replies = []
                            replies = newReplies
                        }
                    }
                    
                    Spacer()
                    // textbox
                    HStack {
                        
                        TextField("Reply", text: $caption, axis: .vertical)
                            .padding(.vertical, 2.5)
                            
                        
                        Spacer()
                        if posting {
                            ProgressView()
                        }
                        
                        ProgressWheel(characterCount: caption.count, maxCharacterCount: 300)
                        
                        Group {
                            if Checks.isValidCommentCaption(caption) {
                                Button {
                                    posting.toggle()
                                    hideKeyboard()
                                    Task {
                                        let captionToUpload = caption
                                        caption = ""
                                        try await viewModel.uploadReply(user: user, comment: comment, caption: captionToUpload)
                                        posting.toggle()
                                        
                                        // update replies
                                        replies = try await FetchService.fetchCommentRepliesByCommentId(comment: comment)
                                    }
                                    
                                    
                                } label: {
                                    Text("Post")
                                        .font(.subheadline)
                                        .foregroundStyle(Color(.systemBlue))
                                }
                            } else {
                                Text("Post")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.systemGray))
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
            } else if failed {
                Text("Failed to load comment, it may no longer exist.")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .padding(.horizontal)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(Color(.clear))
                    .onAppear {
                        Task {
                            do {
                                comment = try await FetchService.fetchCommentByPostAndCommentId(postId: replyAlert.postId, commentId: replyAlert.commentId)
                                post = try await FetchService.fetchPostByPostId(postId: replyAlert.postId)
                                if let comment = comment, let _ = post {
                                    let blockedByUser = x.blockedBy.contains { block in
                                        return block.userId == comment.userId
                                    }
                                    
                                    let blockedUser = x.blocked.contains { block in
                                        return block.userToBlockId == comment.userId
                                    }
                                    
                                    self.hidden = blockedByUser || blockedUser
                                    
                                    replies = try await FetchService.fetchCommentRepliesByCommentId(comment: comment)
                                } else {
                                    failed = true
                                }
                            } catch {
                                failed = true
                            }
                        }
                    }
            }
        }
    }
}

