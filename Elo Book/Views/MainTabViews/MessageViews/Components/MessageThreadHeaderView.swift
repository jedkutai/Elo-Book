//
//  MessageThreadHeaderView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher

struct MessageThreadHeaderView: View {
    @Binding var user: User
    @State var receivingUser: User
    @Binding var thread: Thread
    
    var dismiss: DismissAction
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            }
            
            Spacer()
            
            
            VStack {
                SquareProfilePicture(user: receivingUser, size: .shmedium)
                
                HStack {
                    if let fullname = receivingUser.fullname {
                        Text("\(fullname)")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let username = receivingUser.username {
                        Text("\(username)")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    if let displayedBadge = receivingUser.displayedBadge {
                        BadgeDiplayer(badge: displayedBadge)
                    }
                    
                }
            }
            
            Spacer()
            
            NavigationLink {
                 MessageInfoPage(user: user, viewedUser: receivingUser).navigationBarBackButtonHidden()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            }
            
        }
        .frame(height: 40)
        .padding()
    }
}
