//
//  CommentCellExpaned.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import SwiftUI

struct CommentCellExpaned: View {
    @Binding var user: User
    @State var comment: Comment
    
    
    @State private var replies: [Reply] = []
    
    @State private var posting = false
    @State private var caption: String = ""
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @StateObject private var viewModel = UploadReply()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if self.hidden {
                Text("Failed to load page.")
                     .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                     .padding(.horizontal)
                     .multilineTextAlignment(.center)
            } else {
                VStack {
                    CommentCell(user: user, comment: comment)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(replies, id: \.id) { reply in
                            ReplyCell(user: $user, reply: reply)
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
                .onAppear {
                    let blockedByUser = x.blockedBy.contains { block in
                        return block.userId == comment.userId
                    }
                    
                    let blockedUser = x.blocked.contains { block in
                        return block.userToBlockId == comment.userId
                    }
                    
                    self.hidden = blockedByUser || blockedUser
                    
                    Task {
                        replies = try await FetchService.fetchCommentRepliesByCommentId(comment: comment)
                    }
                }
            }
        }
    }
}


