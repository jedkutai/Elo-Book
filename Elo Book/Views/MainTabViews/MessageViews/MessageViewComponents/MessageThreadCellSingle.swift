//
//  MessageThreadCellSingle.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageThreadCellSingle: View {
    @State var user: User
    @State var threadUser: User
    @State var thread: Thread
    @State var lastMessage: Message2
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            // Profile image
            SquareProfilePicture(user: threadUser, size: .shmedium)
            VStack {
                // other users fullname, username and badge
                HStack {
                    if let fullname = threadUser.fullname {
                        Text(fullname)
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let username = threadUser.username {
                        Text(username)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    if let displayedBadge = threadUser.displayedBadge {
                        BadgeDiplayer(badge: displayedBadge)
                    }
                    Spacer()
                }
                // text of the last message
                HStack {
                    if let caption = lastMessage.caption {
                        Text(caption)
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                    Spacer()
                }
            }
            
            Spacer()
            
            // blue indicator if last message hasnt been seen by you
            if let messageSeenBy = lastMessage.messageSeenBy {
                if !messageSeenBy.contains(user.id) {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(Color(.systemYellow))
                }
            }
            // time to show how long ago message was sent
            Text(DateFormatter.shortDate(timestamp: thread.lastMessageTimeStamp))
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
    }
}


