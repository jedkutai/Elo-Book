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
                
                ScrollView {
                    if let threads = threads {
                        LazyVStack {
                            ForEach(threads, id: \.id) { thread in
                                // probably gonna want to make a group chat version and a regular 1 on 1 chat version again
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
            
        }
    }
}
