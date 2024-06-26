//
//  MessageThreadCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageThreadCell: View {
    @Binding var user: User
    @State var thread: Thread
    
    @State private var failed = false
    @State private var threadUser: User? // if there is only one other user, user this
    @State private var threadUsers: [User]? // if theres a few users, user this
    @State private var lastMessage: Message2?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if !failed {
                Group {
                    if let threadUser = threadUser, let lastMessage = lastMessage { // just you and another person
                        MessageThreadCellSingle(user: user, threadUser: threadUser, thread: thread, lastMessage: lastMessage)
                        
                    } else if let threadUsers = threadUsers, let lastMessage = lastMessage { // group chat with the fellas
                        MessageThreadCellGroup(user: user, threadUsers: threadUsers, thread: thread, lastMessage: lastMessage)
                    } else {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(Color(.clear))
                    }
                }
                .padding(.horizontal, 10)
                
                Divider()
                    .frame(height: 1)
            }
        }
        .onAppear {
            Task {
                do {
                    lastMessage = try await FetchService.fetchLastMessageByThread(thread: thread)
                    if let memberIds = thread.memberIds { // make sure there are users in the thread
                        
                        let otherUserIds = memberIds.filter( { $0 != user.id } )
                        if otherUserIds.count == 1 {
                            if otherUserIds[0] == user.id {
                                failed = true
                            } else {
                                threadUser = try await FetchService.fetchUserById(withUid: otherUserIds[0])
                            }
                            
                            
                        } else if memberIds.count > 2 {
                            threadUsers = try await FetchService.fetchUsersByUserIds(userIds: otherUserIds)
                            if let threadUsers = threadUsers {
                                if threadUsers.count != memberIds.count - 1 {
                                    if threadUsers.count < 2 {
                                        failed = true
                                    }
                                }
                            }
                        } else {
                            failed = true
                        }
                    }
                } catch {
                    failed = true
                }
            }
        }
    }
    
    
}
