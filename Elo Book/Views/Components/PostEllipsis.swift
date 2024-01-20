//
//  PostEllipsis.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/18/24.
//

import SwiftUI

struct PostEllipsis: View {
    @Binding var user: User
    @Binding var postUser: User
    @Binding var post: Post
    @Binding var showMore: Bool
    @Binding var showDeleteWarning: Bool
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if showMore {
            if user.id == postUser.id {
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
                NavigationLink {
                    ReportPostView(user: user, postUser: postUser, post: post)
                } label: {
                    Label("Report", systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(Color(.orange))
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

