//
//  ThreadGroupInfoView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/17/24.
//

import SwiftUI

struct ThreadGroupInfoView: View {
    @Binding var user: User
    @Binding var threadUsers: [User]
    @Binding var thread: Thread
    @Binding var leftGroup: Bool
    
    @State private var showThreadUsers = false
    @State private var showAddMembersView = false
    @State private var leaveGroupWarning = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Button {
                            showThreadUsers.toggle()
                        } label: {
                            HStack {
                                VStack {
                                    HStack {
                                        Text("Group Members")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text(self.createThreadTitle(users: threadUsers))
                                            .foregroundStyle(Color(.systemGray))
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        
                                        Spacer()
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: showThreadUsers ? "chevron.down.circle" : "chevron.right.circle")
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                        
                        if showThreadUsers {
                            
                            
                            ForEach(threadUsers, id: \.id) { threadUser in
                                Divider()
                                    .frame(height: 1)
                                
                                NavigationLink {
                                    AltUserProfileView(user: user, viewedUser: threadUser)
                                } label: {
                                    UserResultCell(user: threadUser)
                                }
                            }
                        }
                        
                        
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                    )
                    .padding(10)
                    
                    if threadUsers.count <= 48 && !leftGroup {
                        HStack {
                            Spacer()
                            
                            NavigationLink {
                                AddUsersToGroupChatView(user: $user, threadUsers: $threadUsers, thread: $thread)
                            } label: {
                                Text("Add Members")
                                    .foregroundStyle(Color(.systemBlue))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                
                
                if !leftGroup {
                    Button {
                        // leave group
                        // get the warning pop up
                        leaveGroupWarning.toggle()
                    } label: {
                        Text("Leave Group")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 32)
                            .background(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                            .foregroundStyle(Color(.systemRed))
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(.gray, lineWidth: 1))
                    }
                }
            }
            .alert(isPresented: $leaveGroupWarning) {
                Alert(
                    title: Text("Leave Group"),
                    message: Text("Are you sure that you want to leave?"),
                    primaryButton: .destructive(Text("Leave")) {
                        Task {
                            try await MessageService.leaveGroupChat(user: user, thread: thread)
                            
                            leftGroup = true
                            
                            let updatedThread = try await FetchService.fetchThreadById(id: thread.id)
                            thread = updatedThread
                            
                            if let memberIds = thread.memberIds {
                                let otherUserIds = memberIds.filter( { $0 != user.id } )
                                
                                let updatedThreadUsers = try await FetchService.fetchUsersByUserIds(userIds: otherUserIds)
                                threadUsers = []
                                threadUsers = updatedThreadUsers
                            }
                            
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )

            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        SquareGroupChatPicture(thread: thread, size: .small)
                        
                        if let threadName = thread.threadName {
                            Text(threadName)
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        } else {
                            Text(self.createThreadTitle(users: threadUsers))
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        }
                    }
                }
            }
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
