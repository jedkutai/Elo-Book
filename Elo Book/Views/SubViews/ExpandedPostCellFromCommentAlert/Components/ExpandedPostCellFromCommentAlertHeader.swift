//
//  ExpandedPostCellFromCommentAlertHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct ExpandedPostCellFromCommentAlertHeader: View {
    @Binding var user: User
    @State var post: Post
    @Binding var showMore: Bool
    @Binding var postDeleted: Bool
    @State private var showDeleteWarning = false
    @State var reportViewToggle = false
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if self.hidden {
            Text("Failed to load page.")
                 .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                 .padding(.horizontal)
                 .multilineTextAlignment(.center)
        } else {
            HStack {
                HStack {
                    SquareProfilePicture(user: user, size: .xSmall)
                    
                    if let fullname = user.fullname {
                        Text(fullname)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let username = user.username {
                        Text(username)
                            .font(.footnote)
                            .foregroundColor(Color(.systemGray))
                    }
                    
                    if let badge = user.displayedBadge {
                        BadgeDisplayer(badge: badge)
                    }
                }
                
                Spacer()
                
                PostEllipsis(user: $user, postUser: $user, post: $post, showMore: $showMore, showDeleteWarning: $showDeleteWarning)
                
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
            .onAppear {
                let blockedByUser = x.blockedBy.contains { block in
                    return block.userId == post.userId
                }
                
                let blockedUser = x.blocked.contains { block in
                    return block.userToBlockId == post.userId
                }
                
                self.hidden = blockedByUser || blockedUser
            }
        }

    }
}

