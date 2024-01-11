//
//  StaticPostCellHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct StaticPostCellHeader: View {
    @Binding var postUser: User
    @Binding var post: Post
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
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 8)
    }
}
