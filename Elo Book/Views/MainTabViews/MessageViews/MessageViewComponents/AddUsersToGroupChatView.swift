//
//  AddUsersToGroupChatView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/17/24.
//

import SwiftUI

struct AddUsersToGroupChatView: View {
    @Binding var user: User
    @Binding var threadUsers: [User]
    @Binding var thread: Thread
    
    
    @State private var searchText = ""
    @State private var searchDatabaseText = ""
    @State private var newUsers: [User] = []
    @State private var someUsers: [User] = []
    @State private var filteredUsers: [User] = []
    
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                // shows the new users
                if !newUsers.isEmpty {
                    HStack {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(Array(newUsers.enumerated()), id: \.0) { index, newUser in
                                    Button {
                                        newUsers.remove(at: index)
                                        
                                    } label: {
                                        if index > 0 {
                                            Text(",")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        }
                                        
                                        HStack {
                                            
                                            SquareProfilePicture(user: newUser, size: .xSmall)
                                            
                                            if let fullname = newUser.fullname {
                                                Text("\(fullname)")
                                                    .font(.footnote)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                            }
                                            
                                            if let username = newUser.username {
                                                Text("\(username)")
                                                    .font(.footnote)
                                                    .foregroundStyle(Color(.systemGray))
                                            }
                                            
                                            if let displayedBadge = newUser.displayedBadge {
                                                BadgeDisplayer(badge: displayedBadge)
                                            }
                                            
                                            Spacer()
                                            
                                            
                                        }
                                        .padding(.leading, 10)

                                    }
                                }
                            }
                        }
                        .frame(height: 30)
                    }
                    .padding(.horizontal, 10)
                }
                
                // Search bar
                HStack { // search bar
                    TextField("Find Users", text: $searchText, axis: .vertical)
                        .autocapitalization(.none)
                        .padding(.vertical, 2.5)
                    
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 10)
                
                
                VStack { // show search results
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(filteredUsers, id: \.id) { filteredUser in
                            if filteredUser.id != user.id {
                                if !newUsers.contains(where: { $0.id == filteredUser.id }) {
                                    if !threadUsers.contains(where: { $0.id == filteredUser.id }) {
                                        Button {
                                            if threadUsers.count + newUsers.count < 48 { // max group members is 50, 48 plus you is 49 plus next person to add is 50
                                                newUsers.append(filteredUser)
                                                searchText = ""
                                            }
                                        } label: {
                                            HStack {
                                                SquareProfilePicture(user: filteredUser, size: .xSmall)
                                                
                                                if let fullname = filteredUser.fullname {
                                                    Text("\(fullname)")
                                                        .font(.footnote)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                                }
                                                
                                                if let username = filteredUser.username {
                                                    Text("\(username)")
                                                        .font(.footnote)
                                                        .foregroundStyle(Color(.systemGray))
                                                }
                                                
                                                if let displayedBadge = filteredUser.displayedBadge {
                                                    BadgeDisplayer(badge: displayedBadge)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            
                                            
                                        }
                                        Divider()
                                            .frame(height: 1)
                                    }
                                }
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .padding(.horizontal, 10)
                }
                
                Spacer()
            }
            .navigationTitle("Add Members")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !newUsers.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // save changes
                            Task {
                                try await MessageService.addUsersToGroupChat(usersToAdd: newUsers, thread: thread)
                                // fetch new threead
                                let updatedThread = try await FetchService.fetchThreadById(id: thread.id)
                                thread = updatedThread
                                
                                if let memberIds = thread.memberIds {
                                    let otherUserIds = memberIds.filter( { $0 != user.id } )
                                    
                                    let updatedThreadUsers = try await FetchService.fetchUsersByUserIds(userIds: otherUserIds)
                                    threadUsers = []
                                    threadUsers = updatedThreadUsers
                                }
                                
                                dismiss()
                            }
                        } label: {
                            Text("Add")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    }
                }
            }
            
            .onChange(of: searchText) {
                if searchText.count < 1 {
                    searchDatabaseText = ""
                } else if searchText.count >= 1 {
                    searchDatabaseText = String(searchText.prefix(1))
                }
                
                filteredUsers = SearchService.searchLocallyForUsernames(searchText: searchText, users: someUsers, limit: 10)
            }
            .onChange(of: searchDatabaseText) {
                if !searchDatabaseText.isEmpty {
                    if Checks.isValidSearch(searchDatabaseText) {
                        Task {
                            someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                        }
                    } else {
                        someUsers = []
                    }
                } else {
                    someUsers = []
                }
            }
        }
    }
}
