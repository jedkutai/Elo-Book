//
//  MessageViewHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageViewHeader: View {
    @Binding var user: User
    @Binding var showCreateNewMessage: Bool
    @Binding var unreadMessageCount: Int
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
//            
//            SquareProfilePicture(user: user, size: .shmedium)
            
            if unreadMessageCount == 0 {
                Text("Messages")
                    .fontWeight(.bold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                
            } else if unreadMessageCount == 1 {
                Text("\(unreadMessageCount) MESSAGE")
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.systemOrange))
            } else if unreadMessageCount < 10 {
                Text("\(unreadMessageCount) MESSAGES")
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.systemOrange))
            } else {
                Text("10+ MESSAGES")
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.systemOrange))
            }
            
            Spacer()
            
            NavigationLink {
                CreateNewMessageView(user: user)
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
            }
            
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
