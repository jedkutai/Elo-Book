//
//  PostCellWithStaticHeaderHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct PostCellWithStaticHeaderHeader: View {
    @Binding var user: User
    @State var postUser: User
    @Binding var post: Post
    @Binding var showMore: Bool
    @Binding var postDeleted: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            HStack {
                SquareProfilePicture(user: postUser, size: .xSmall)
                
                if let fullname = postUser.fullname {
                    Text("\(fullname)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                }
                
                if let username = postUser.username {
                    Text("\(username)")
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
                        postDeleted = true
                        Task {
                            try await PostService.deletePost(post: post)
                        }
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
    }
}