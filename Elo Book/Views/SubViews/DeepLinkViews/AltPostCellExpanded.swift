//
//  AltPostCellExpanded.swift
//  EloBookv1
//
//  Created by Jed Kutai on 1/1/24.
//

import SwiftUI
import Kingfisher

struct AltPostCellExpanded: View {
    @State var user: User
    @State var postUser: User
    @State var post: Post
    @State private var comments: [Comment] = []
    
    @State private var commentCount: Int = 0
    @State private var likes: [PostLike] = []
    
    @State private var events: [Event]?
    @State private var caption = ""
    @State private var posting = false
    @State private var loadingMorePosts = false
    @State private var swipeStarted = false
    @State private var showMore = false
    @State private var postDeleted = false
    @StateObject private var viewModel = UploadComment()
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    private let imageWidth = UIScreen.main.bounds.width * 0.85
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
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVStack {
                            PostCellExpandedHeader(user: $user, postUser: $postUser, post: $post, showMore: $showMore, postDeleted: $postDeleted)
                            
                            PostCellExpandedBody2(user: $user, viewUser: $postUser, post: $post)
                            
                            PostCellExpandedFooter(user: $user, postUser: $postUser, post: $post, comments: $comments, likes: $likes, commentCount: $commentCount)
                        }
                        .padding(10)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color(.gray).opacity(0.15))
                        )
                        .padding(.top, 2)
                        
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
                .toolbar {
                    if let events = events {
                        ToolbarItem(placement: .topBarTrailing) {
                            EventsHorizontalScroll(user: $user, events: events)
                        }
                    }
                }
                .onAppear {
                    let blockedByUser = x.blockedBy.contains { block in
                        return block.userId == postUser.id
                    }
                    
                    let blockedUser = x.blocked.contains { block in
                        return block.userToBlockId == postUser.id
                    }
                    
                    self.hidden = blockedByUser || blockedUser
                    
                    Task {
                        if let eventIds = post.eventIds {
                            events = try await FetchService.fetchEventsByEventIds(eventIds: eventIds)
                        }
                        likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                        comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                        commentCount = try await FetchService.fetchCommentCountByPost(postId: post.id)
                    }
                }
            }
            
        }
    }
}
