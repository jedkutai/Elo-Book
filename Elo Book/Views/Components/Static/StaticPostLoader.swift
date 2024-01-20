//
//  StaticPostLoader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/16/24.
//

import SwiftUI

struct StaticPostLoader: View {
    @State var user: User
    @State var postId: String
    
    @State private var postUser: User?
    @State private var post: Post?
    @State private var failed = false
    var body: some View {
        if let postUser = postUser, let post = post {
            NavigationLink {
//                AltPostCellExpanded(user: user, postUser: postUser, post: post).navigationBarBackButtonHidden()
                AltPostCellExpanded(user: user, postUser: postUser, post: post)
            } label: {
                StaticPostCell(user: user, postUser: postUser, post: post)
            }
        } else if failed {
            Text("failed to load post")
                .font(.footnote)
                .foregroundStyle(Color(.systemGray))
        } else {
            ProgressView("Loading Post...")
                .onAppear {
                    Task {
                        if !postId.isEmpty {
                            post = try await FetchService.fetchPostByPostId(postId: postId)
                            if let post = post {
                                postUser = try await FetchService.fetchUserById(withUid: post.userId)
                            } else {
                                failed = true
                            }
                        } else {
                            failed = true
                        }
                    }
                }
        }
    }
}
