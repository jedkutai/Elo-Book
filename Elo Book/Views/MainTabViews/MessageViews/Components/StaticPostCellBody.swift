//
//  StaticPostCellBody.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct StaticPostCellBody: View {
    @Binding var post: Post
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let caption = post.caption {
            Group {
                if caption.count > 200 {
                    Text("\(String(caption.prefix(125)))")
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                    Text("...")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    
                        
                    
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
        }
        
        if let imageUrls = post.imageUrls {
            StaticPostImageView(imageUrls: imageUrls)
        }
    }
}
