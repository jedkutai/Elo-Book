//
//  MessageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageView: View {
    @Binding var user: User
    @Binding var threads: [Thread]
    @Binding var unreadMessageCount: Int
    
    @State private var showCreateNewMessage = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                MessageViewHeader(user: $user, showCreateNewMessage: $showCreateNewMessage, unreadMessageCount: $unreadMessageCount)
                
                Divider()
                    .frame(height: 1)
                
                // Body
                ScrollView {
                    VStack {
                        ForEach(threads, id: \.id) { thread in
                            NavigationLink {
                                if let memberIds = thread.memberIds {
                                    if memberIds.count >= 2 {
                                        ThreadView(user: user, thread: thread)
                                    }
                                }
                            } label: {
                                MessageThreadCell(user: $user, thread: thread)
                            }
                            
                            Divider()
                                .frame(height: 1)
                        }
                    }
                    .padding(.top, 5)
                    
                    
                }
                .refreshable {
                    refreshThreads()
                }
                
            }
            .fullScreenCover(isPresented: $showCreateNewMessage) {
                CreateNewMessageView(user: user)
            }
            .onAppear {
                refreshThreads()
            }
            
        }
    }
    
    private func refreshThreads() {
        // refresh action, fetch threads and update user etc
        threads = []
        Task {
            threads = try await FetchService.fetchMessageThreadsByUser(user: user)
            unreadMessageCount = try await MessageService.unreadMessagesCount(user: user, threads: threads)
        }
    }
}
