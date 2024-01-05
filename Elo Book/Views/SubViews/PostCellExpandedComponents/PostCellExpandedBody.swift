//
//  PostCellExpandedBody.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct PostCellExpandedBody: View {
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
            
        if let imageUrls = post.imageUrls {
            PostImageView(imageUrls: imageUrls)
        }
    }
}
