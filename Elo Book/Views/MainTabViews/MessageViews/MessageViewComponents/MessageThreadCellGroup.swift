//
//  MessageThreadCellGroup.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import SwiftUI

struct MessageThreadCellGroup: View {
    @State var user: User
    @State var threadUsers: [User]
    @State var thread: Thread
    @State var lastMessage: Message2
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            // group photo or generic
            SquareGroupChatPicture(thread: thread, size: .shmedium)
            
            VStack {
                HStack {
                    if let threadName = thread.threadName {
                        Text(threadName)
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    } else {
                        Text(self.createThreadTitle(users: threadUsers))
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    Spacer()
                    
                }
                
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
    
    private func createThreadTitle(users: [User]) -> String {
        var usernames: [String] = []
        for user in users {
            if let username = user.username {
                if !usernames.contains(username) {
                    usernames.append(username)
                }
            }
        }
        
        let title = usernames.joined(separator: ", ")
        
        
        return title
    }
}


