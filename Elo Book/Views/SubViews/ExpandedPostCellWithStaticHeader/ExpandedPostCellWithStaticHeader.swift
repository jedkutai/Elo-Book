//
//  ExpandedPostCellWithStaticHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct ExpandedPostCellWithStaticHeader: View {
    @State var user: User
    @State var postUser: User
    @State var post: Post
    @Binding var comments: [Comment]
    @Binding var likes: [PostLike]
    @Binding var commentCount: Int
    @Binding var postDeleted: Bool
    @Binding var showMore: Bool
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @State private var events: [Event]?
    @State private var posting: Bool = false
    @State private var loadingMorePosts: Bool = false
    @State private var caption: String = ""
    @StateObject private var viewModel = UploadComment()
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
                    
                    ScrollView {
                        VStack {
                            ExpandedPostCellWithStaticHeaderHeader(user: $user, postUser: $postUser, post: $post, postDeleted: $postDeleted, showMore: $showMore)
                            PostCellExpandedBody2(user: $user, viewUser: $postUser, post: $post)
                            PostCellExpandedFooter(user: $user, postUser: $postUser, post: $post, comments: $comments, likes: $likes, commentCount: $commentCount)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color(.gray).opacity(0.15))
                        )
                        .padding(.top, 2)
                        .padding(.horizontal)
                        
                        
                        ForEach(comments, id: \.id) { comment in
                            NavigationLink {
                                CommentCellExpaned(user: $user, comment: comment)
                            } label: {
                                CommentCell(user: user, comment: comment)
                            }
                        }
//                        .padding(10)
                        
                        if comments.count >= 20 {
                            Button {
                                if !loadingMorePosts {
                                    loadingMorePosts.toggle()
                                    Task {
                                        comments = try await FetchService.fetchMoreCommentsByPostId(postId: post.id, limit: comments.count)
                                        loadingMorePosts.toggle()
                                    }
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    
                                    if loadingMorePosts {
                                        ProgressView()
                                    } else {
                                        Text("Load more")
                                            .font(.footnote)
                                            .foregroundStyle(Color(.gray).opacity(0.3))
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .refreshable {
                        likes = []
                        comments = []
                        events = []
                        Task {
                            if let eventIds = post.eventIds {
                                events = try await FetchService.fetchEventsByEventIds(eventIds: eventIds)
                            }
                            likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                            comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                            commentCount = try await FetchService.fetchCommentCountByPost(postId: post.id)
                        }
                    }
                    
                    PostCellExpandedTextBox(user: $user, post: $post, likes: $likes, comments: $comments, posting: $posting, caption: $caption, viewModel: viewModel)
                }
                .onAppear {
                    let blockedByUser = x.blockedBy.contains { block in
                        return block.userId == post.userId
                    }
                    
                    let blockedUser = x.blocked.contains { block in
                        return block.userToBlockId == post.userId
                    }
                    
                    self.hidden = blockedByUser || blockedUser
                    
                    Task {
                        if let eventIds = post.eventIds {
                            events = try await FetchService.fetchEventsByEventIds(eventIds: eventIds)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        if let events = events {
                            if !events.isEmpty {
                                EventsHorizontalScroll(user: $user, events: events)
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}
