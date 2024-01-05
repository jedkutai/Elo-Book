//
//  PostCellBody.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct PostCellBody: View {
    @Binding var post: Post
    @Binding var expandPost: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let caption = post.caption {
            Group {
                if caption.count > 200 {
                    Text("\(String(caption.prefix(125)))")
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                    Button {
                        expandPost.toggle()
                    } label: {
                        Text("... Tap to expand.")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                        
                    
                    Spacer()
                } else {
                    HStack {
                        Text(caption)
                            .font(.footnote)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                }
            }
            .onTapGesture {
                expandPost.toggle()
            }
        }
        
        if let imageUrls = post.imageUrls {
            PostImageView(imageUrls: imageUrls)
        }
    }
}
