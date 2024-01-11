//
//  MessageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct MessageView: View {
    @Binding var user: User
    @State private var threads: [Thread]?
    @State private var showCreateNewMessage = false
    @State private var number = 0
    @State private var messagePageReloadTrigger = false // flip every minute
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    
                    SquareProfilePicture(user: user, size: .shmedium)
                    
                    Text("MESSAGES")
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Spacer()
                    
                    Button {
                        showCreateNewMessage.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                }
                .padding(.horizontal)
                
                ScrollView {
                    
                    Divider()
                        .frame(height: 1)
                    
                    if let threads = threads {
                        LazyVStack {
                            ForEach(threads, id: \.id) { thread in
                                if thread.userIds.count > 2 {
                                    NavigationLink {
    //                                    GroupMessageThreadView(thread: thread, user: user).navigationBarBackButtonHidden()
                                    } label: {
                                        GroupMessageThreadCell(thread: thread, user: user)
                                    }
                                } else {
                                    NavigationLink {
                                        MessageThreadView(thread: thread, user: user).navigationBarBackButtonHidden()
                                    } label: {
                                        MessageThreadCell(thread: thread, user: user)
                                    }
                                }
                                
                                Divider()
                                    .frame(height: 1)
                            }
                        }
                        .padding(.top, 5)
                    }
                }
                .refreshable {
                    threads = nil
                    Task {
                        threads = try await FetchService.fetchMessageThreadsByUser(user: user)
                    }
                }
                
            }
            .fullScreenCover(isPresented: $showCreateNewMessage) {
                CreateStandardMessageView(user: $user)
            }
            .onAppear {
                Task {
                    threads = try await FetchService.fetchMessageThreadsByUser(user: user)
                    messagePageReloadTrigger.toggle()
                }
            }
        }
    }
}
