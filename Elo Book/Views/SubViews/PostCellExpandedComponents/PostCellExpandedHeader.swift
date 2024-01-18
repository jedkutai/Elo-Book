//
//  PostCellExpandedHeader.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct PostCellExpandedHeader: View {
    @Binding var user: User
    @Binding var postUser: User
    @Binding var post: Post
    @Binding var showMore: Bool
    @Binding var postDeleted: Bool
    @State private var showDeleteWarning = false
    @State var reportViewToggle = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
            NavigationLink {
                AltUserProfileView(user: user, viewedUser: postUser)
            } label: {
                HStack {
                    SquareProfilePicture(user: postUser, size: .xSmall)
                    
                    if let fullname = postUser.fullname {
                        Text(fullname)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let username = postUser.username {
                        Text(username)
                            .font(.footnote)
                            .foregroundColor(Color(.systemGray))
                    }
                    
                    if let badge = postUser.displayedBadge {
                        BadgeDiplayer(badge: badge)
                    }
                }
            }
            
            Spacer()
            
            PostEllipsis(user: $user, postUser: $postUser, post: $post, showMore: $showMore, showDeleteWarning: $showDeleteWarning)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .padding(.horizontal, 8)
        .alert(isPresented: $showDeleteWarning) {
            Alert(
                title: Text("Delete Post"),
                message: Text("Deleting a post is irreversible."),
                primaryButton: .destructive(Text("Delete")) {
                    postDeleted = true
                    dismiss()
                    Task {
                        try await PostService.deletePost(post: post)
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )

        }

    }
}
