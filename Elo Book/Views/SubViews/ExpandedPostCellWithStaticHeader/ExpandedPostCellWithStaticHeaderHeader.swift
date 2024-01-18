//
//  ExpandedPostCellWithStaticHeaderHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct ExpandedPostCellWithStaticHeaderHeader: View {
    @Binding var user: User
    @Binding var postUser: User
    @Binding var post: Post
    @Binding var postDeleted: Bool
    @Binding var showMore: Bool
    @State private var showDeleteWarning = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
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
            
            Spacer()
            
            if user.id == postUser.id {
                if showMore {
                    Button {
                        showDeleteWarning.toggle()
                    } label: {
                        HStack {
                            Label("Delete", systemImage: "trash")
                                .font(.footnote)
                                .foregroundStyle(Color(.red))
                            
                        }
                    }
                } else {
                    Button {
                        showMore.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                }
            }
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

