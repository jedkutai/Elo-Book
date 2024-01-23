//
//  ExpandedPostCellFromCommentAlert.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI
import Kingfisher

struct ExpandedPostCellFromCommentAlert: View {
    @State var user: User
    @State var commentAlert: CommentOnPostAlert
    @State var targetComment: Comment
    @State var post: Post?
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
    @State private var failed = false
    @StateObject private var viewModel = UploadComment()
    @Environment(\.dismiss) private var dismiss
    
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if let post = post {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVStack {
                            ExpandedPostCellFromCommentAlertHeader(user: $user, post: post, showMore: $showMore, postDeleted: $postDeleted)
                            
                            ExpandedPostCellFromCommentAlertBody(user: $user, post: post)
                            
                            ExpandedPostCellFromCommentAlertFooter(user: $user, post: post, comments: $comments, likes: $likes, commentCount: $commentCount)
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
                                if comment.id == targetComment.id {
                                    CommentCell(user: user, comment: comment)
                                        .padding(5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 2.5)
                                                .stroke(Color(.systemYellow), lineWidth: 2)
                                        )
                                } else {
                                    CommentCell(user: user, comment: comment)
                                }
                                
                            }
                            
                        }
                        
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
                                likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                                commentCount = try await FetchService.fetchCommentCountByPost(postId: post.id)
                                
                                var loadedComments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                                
                                
                                if let indexToRemove = loadedComments.firstIndex(where: {$0.id == targetComment.id}) {
                                    loadedComments.remove(at: indexToRemove)
                                }
                                loadedComments.insert(targetComment, at: 0)
                                comments = loadedComments
                            }
                        }
                    }
                    
                    ExpandedPostCellFromCommentAlertTextBox(user: $user, post: post, likes: $likes, comments: $comments, posting: $posting, caption: $caption, viewModel: viewModel)
                }
                .toolbar {
                    if let events = events {
                        ToolbarItem(placement: .topBarTrailing) {
                            EventsHorizontalScroll(user: $user, events: events)
                        }
                    }
                }
            } else if failed {
                Text("Failed to load post, it may no longer exist.")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .padding(.horizontal)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(Color(.clear))
                    .onAppear {
                        Task {
                            
                            // fetch post
                            do {
                                post = try await FetchService.fetchPostByPostId(postId: commentAlert.postId)
                            } catch {
                                failed = true
                            }
                            // fetch comments
                            if let post = post {
                                if let eventIds = post.eventIds {
                                    events = try await FetchService.fetchEventsByEventIds(eventIds: eventIds)
                                    likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                                    commentCount = try await FetchService.fetchCommentCountByPost(postId: post.id)
                                    
                                    var loadedComments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                                    
                                    
                                    if let indexToRemove = loadedComments.firstIndex(where: {$0.id == targetComment.id}) {
                                        loadedComments.remove(at: indexToRemove)
                                    }
                                    loadedComments.insert(targetComment, at: 0)
                                    comments = loadedComments
                                }
                            } else {
                                failed = true
                            }
                            // insert comment into top of comment array
                            // fetch events
                            // fetch likes
                        }
                    }
            }
            
        }
    }
}
