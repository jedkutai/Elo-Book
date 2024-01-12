//
//  UserResultCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct UserResultCell: View {
    @State var user: User
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            SquareProfilePicture(user: user, size: .small)
            
            VStack {
                if let fullname = user.fullname {
                    HStack {
                        Text(fullname)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                        Spacer()
                    }
                }
                
                if let username = user.username {
                    HStack {
                        Text("@\(username)")
                            .font(.footnote)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                        if let displayedBadge = user.displayedBadge {
                            BadgeDiplayer(badge: displayedBadge)
                        }
                        
                        Spacer()
                    }
                }
                
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        
    }
}
