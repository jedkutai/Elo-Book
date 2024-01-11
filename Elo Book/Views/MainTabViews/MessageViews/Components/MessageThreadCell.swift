//
//  MessageThreadCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI
import Kingfisher

struct MessageThreadCell: View {
    @State var thread: Thread
    @State var user: User
    @State private var receivingUser: User?
    @State private var lastMessage: Message?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            HStack {
                
                if let receivingUser = receivingUser {
                    SquareProfilePicture(user: receivingUser, size: .shmedium)
                    
                    VStack {
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
                
                
            }
            .frame(height: 40)
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                receivingUser = try await FetchService.fetchMessageUserByThread(thread: thread, user: user)
                if let lastMessageId = thread.lastMessageId {
                    lastMessage = try await FetchService.fetchLastMessageByThreadAndMessageId(threadId: thread.id, lastMessageId: lastMessageId)
                }
            }
        }
    }
}
