//
//  PostCellBody2.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

import SwiftUI

struct PostCellBody2: View {
    @State var user: User
    @State var viewedUser: User
    @State var post: Post
    @State private var showMore: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let caption = post.caption {
            Group {
                if showMore {
                    Text(caption)
                        .font(.subheadline)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                    
                    Button {
                        showMore.toggle()
                    } label: {
                        Text("show less")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                } else {
                    if caption.count > 200 {
                        
                        Button {
                            showMore.toggle()
                        } label: {
                            Text("\(String(caption.prefix(125)))...SHOW MORE")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .multilineTextAlignment(.leading)
                        }
                        
                            
                        
                        Spacer()
                    } else {
                        HStack {
                            Text(caption)
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .multilineTextAlignment(.leading)
                                
                            Spacer()
                        }
                        
                    }
                }
                
                
            }
            .padding(.horizontal, 8)
            
        }
        
        if post.imageUrls != nil {
//            PostImageView2(user: $user, viewedUser: $viewedUser, post: $post)
            PostImageView3(user: $user, viewedUser: $viewedUser, post: $post)
        }
    }
}
