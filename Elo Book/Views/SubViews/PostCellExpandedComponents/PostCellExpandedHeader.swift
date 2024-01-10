//
//  PostCellExpandedHeader.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct PostCellExpandedHeader: View {
    @Binding var user: User
    @Binding var postUser: User
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            NavigationLink {
                AltUserProfileView(user: user, viewedUser: postUser).navigationBarBackButtonHidden()
            } label: {
                HStack {
                    SquareProfilePicture(user: postUser, size: .xSmall)
                    
                    if let fullname = postUser.fullname {
                        Text(fullname)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let username = postUser.username {
                        Text(username)
                            .font(.footnote)
                            .foregroundColor(Color(.systemGray))
                    }
                    
                    if let badge = postUser.displayedBadge {
                        BadgeDiplayer(badge: badge)
                    }
                }
            }
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .padding(.horizontal, 8)

    }
}
