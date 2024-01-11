//
//  GroupMessageThreadCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI
import Kingfisher

struct GroupMessageThreadCell: View {
    @State var thread: Thread
    @State var user: User
    
    @State private var threadUsers: [User]?
    @State private var lastMessage: Message?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            HStack {
                if let imageUrl = thread.imageUrl {
                    
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: 5 * 0.3)
                        )
                } else {
                    Image(systemName: "person.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(.systemGray4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: 5 * 0.3)
                        )
                }
                
                VStack {
                    HStack {
                        if let threadName = thread.threadName {
                            //
                            Text("\(threadName)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        } else {
                            if let threadUsers = threadUsers {
                                let usernames = self.getGroupChatTitle(threadUsers: threadUsers)
                                
                                Text("\(usernames)")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if let lastMessage = lastMessage {
                        HStack {
                            Text(lastMessage.caption)
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray))
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                if let lastMessageTimeStamp = thread.lastMessageTimeStamp {
                    Text(DateFormatter.shortDate(timestamp: lastMessageTimeStamp))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 40)
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                threadUsers = try await FetchService.fetchGroupMessageUsersByThread(thread: thread, user: user)
                if let lastMessageId = thread.lastMessageId {
                    lastMessage = try await FetchService.fetchLastMessageByThreadAndMessageId(threadId: thread.id, lastMessageId: lastMessageId)
                }
            }
        }
    }
    
    private func getGroupChatTitle(threadUsers: [User]) -> String {
        var usernamesArray: [String] = []
        
        for user in threadUsers {
            if let username = user.username {
                usernamesArray.append(username)
            }
        }
        
        usernamesArray = usernamesArray.sorted()
        let usernames = usernamesArray.joined(separator: ", ")
        
        return usernames
    }
}
