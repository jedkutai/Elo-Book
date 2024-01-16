//
//  StaticPostCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/16/24.
//

import SwiftUI
import Kingfisher

struct StaticPostCell: View {
    @State var user: User
    @State var postUser: User
    @State var post: Post
    
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        SquareProfilePicture(user: postUser, size: .xSmall)
                        
                        if let fullname = postUser.fullname {
                            Text("\(fullname)")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        }
                        
                        if let username = postUser.username {
                            Text("\(username)")
                                .font(.footnote)
                                .foregroundColor(Color(.systemGray))
                        }
                        
                        if let displayedBadege = postUser.displayedBadge {
                            BadgeDiplayer(badge: displayedBadege)
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 8)
                
                if let caption = post.caption {
                    Text("\(caption)")
                        .font(.footnote)
                        .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .padding(.horizontal, 8)
                }
                
                if let imageUrls = post.imageUrls {
                    StaticPostImageView(imageUrls: imageUrls)
                }
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.gray).opacity(0.15))
            )
        }
    }
}

#Preview {
    StaticPostCell(user: User.MOCK_USER, postUser: User.MOCK_USER, post: Post.MOCK_POST)
}


