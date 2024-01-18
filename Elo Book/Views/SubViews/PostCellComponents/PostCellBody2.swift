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
    @State private var showMoreText: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let caption = post.caption {
            Group {
                if showMoreText {
                    Text(caption)
                        .font(.subheadline)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                      
                    
                } else {
                    if caption.count > 200 {
                        
                        Button {
                            showMoreText.toggle()
                        } label: {
                            Group {
                                Text("\(String(caption.prefix(125)))")
                                    .font(.subheadline)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                + Text("...Show more.")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.systemBlue))
                            }
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
            PostImageView3(user: $user, viewedUser: $viewedUser, post: $post)
        }
    }
}

