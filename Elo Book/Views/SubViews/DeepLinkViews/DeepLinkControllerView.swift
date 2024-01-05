//
//  DeepLinkControllerView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 1/1/24.
//

import SwiftUI

enum DeepLinkType {
    case none
    case post
    case user
}

struct DeepLinkControllerView: View {
    @State var deepLinkType: DeepLinkType
    @State var deepLinkId: String
    @State var user: User
    
    @State private var loading = true
    @State private var viewedUser: User?
    
    @State private var post: Post?
    @State private var postUser: User?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if loading {
            waiting
        } else {
            if let viewedUser = viewedUser {
                AltUserProfileView(user: user, viewedUser: viewedUser)
            } else if let post = post, let postUser = postUser {
                AltPostCellExpanded(user: user, postUser: postUser, post: post)
            }
        }
    }
    
    var waiting: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .onAppear {
            if deepLinkType == .post {
                Task {
                    post = try await FetchService.fetchPostByPostId(postId: deepLinkId)
                    if let post = post {
                        postUser = try await FetchService.fetchUserById(withUid: post.userId)
                        
                        loading = false
                    } else {
                        dismiss()
                    }
                }
            } else if deepLinkType == .user {
                Task {
                    viewedUser = try await FetchService.fetchUserByUsername(username: deepLinkId)
                    loading = false
                }
            } else {
                dismiss()
            }
        }
    }
}

