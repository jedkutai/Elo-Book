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
    @StateObject private var viewModel = UploadComment()
    @Environment(\.dismiss) private var dismiss
    
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        }
                        
                        if let events = events {
                            EventsHorizontalScroll(user: $user, events: events)
                        } else {
                            Text("Invisible Invisible")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColor : Theme.buttonColorDarkMode)
                        }
                        
                    }
                    .padding(.leading)
                    
                    LazyVStack {
                        PostCellExpandedHeader(user: $user, postUser: $postUser)
                        
                        PostCellExpandedBody(post: $post)
                        
                        PostCellExpandedFooter(user: $user, post: $post, comments: $comments, likes: $likes, commentCount: $commentCount)
                    }
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width - 20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(.gray).opacity(0.15))
                    )
                    .padding(.top, 2)
                    
                    ForEach(comments, id: \.id) { comment in
                        CommentCell(user: user, comment: comment)
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
                Task {
                    if let eventIds = post.eventIds {
                        events = try await FetchService.fetchEventsByEventIds(eventIds: eventIds)
                    }
                    likes = try await FetchService.fetchPostLikesByPostId(postId: post.id)
                    comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
                    commentCount = try await FetchService.fetchCommentCountByPost(postId: post.id)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.y < 40 {
                            self.swipeStarted = true
                        }
                    }
                    .onEnded { _ in
                        self.swipeStarted = false
                        dismiss()
                    }
            )
            
        }
    }
}
