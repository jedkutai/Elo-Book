//
//  MessageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageView: View {
    @Binding var user: User
    @State private var threads: [Thread]?
    @State private var showCreateNewMessage = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                MessageViewHeader(user: $user, showCreateNewMessage: $showCreateNewMessage)
                
                Divider()
                    .frame(height: 1)
                
                // Body
                ScrollView {
                    if let threads = threads {
                        VStack {
                            ForEach(threads, id: \.id) { thread in
                                NavigationLink {
                                    if let memberIds = thread.memberIds {
                                        if memberIds.count >= 2 {
                                            ThreadView(user: user, thread: thread).navigationBarBackButtonHidden()
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
                    
                    
                }
                .refreshable {
                    refreshThreads()
                }
                
            }
            .fullScreenCover(isPresented: $showCreateNewMessage) {
                CreateNewMessageView(user: user)
            }
            .onAppear {
                threads = []
                refreshThreads()
            }
        }
    }
    
    private func refreshThreads() {
        threads = nil
        // refresh action, fetch threads and update user etc
        Task {
            threads = try await FetchService.fetchMessageThreadsByUser(user: user)
        }
    }
}
