//
//  PostCellExpanded.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI
import Kingfisher

struct PostCellExpanded: View {
    @State var user: User
    @State var postUser: User
    @State var post: Post
    @Binding var comments: [Comment]
    
    @State private var likes: [PostLike] = []
    
    @State private var events: [Event]?
    @State private var caption = ""
    @State private var posting = false
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
                            Image(systemName: "chevron.left")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        }
                        
                        if let events = events {
                            EventsHorizontalScroll(user: $user, events: events)
                        }
                        
                    }
                    .padding(.leading)
                    
                    LazyVStack {
                        PostCellExpandedHeader(user: $user, postUser: $postUser)
                        
                        PostCellExpandedBody(post: $post)
                        
                        PostCellExpandedFooter(user: $user, post: $post, comments: $comments, likes: $likes)
                    }
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width - 20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(.gray).opacity(0.15))
                    )
                    
                    
                    PostCellExpandedComments(user: $user, comments: $comments)
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
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            
        }
    }
}
