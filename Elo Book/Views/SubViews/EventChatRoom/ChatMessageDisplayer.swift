//
//  ChatMessageDisplayer.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

import SwiftUI

struct ChatMessageDisplayer: View {
    @State var user: User
    @State var chat: Chat
    
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                if let username = chat.username {
                    Text(username)
                        .foregroundStyle(Color(user.id == chat.userId ? .systemBlue : .systemGray))
                }
                
                if let displayedBadge = chat.displayedBadge {
                    BadgeDiplayer(badge: displayedBadge)
                }
                
                Spacer()
            }
            
            HStack {
                if let caption = chat.caption {
                    Text(caption)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .padding(.bottom, 5)
                }
                
                Spacer()
            }
            
        }
        .padding(.horizontal)
    }
}
