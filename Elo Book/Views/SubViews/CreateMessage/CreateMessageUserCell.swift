//
//  CreateMessageUserCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct CreateMessageUserCell: View {
    @State var user: User
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            SquareProfilePicture(user: user, size: .xSmall)
            
            if let fullname = user.fullname {
                Text("\(fullname)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            }
            
            if let username = user.username {
                Text("\(username)")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
            }
            
            if let displayedBadge = user.displayedBadge {
                BadgeDiplayer(badge: displayedBadge)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
