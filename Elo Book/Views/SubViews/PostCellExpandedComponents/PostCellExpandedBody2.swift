//
//  PostCellExpandedBody2.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

import SwiftUI

struct PostCellExpandedBody2: View {
    @Binding var user: User
    @Binding var viewUser: User
    @Binding var post: Post
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let caption = post.caption {
            HStack {
                Text(caption)
                    .font(.subheadline)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                Spacer()
            }
            .padding(.horizontal, 8)
            
        }
            
        if post.imageUrls != nil {
            PostImageView3(user: $user, viewedUser: $viewUser, post: $post)
        }
    }
}
