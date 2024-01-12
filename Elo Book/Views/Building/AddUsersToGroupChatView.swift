//
//  AddUsersToGroupChatView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct AddUsersToGroupChatView: View {
    @State var user: User
    @State var receivingUsers: [User]
    @State var thread: Thread
    @Binding var refresh: Bool
    @State private var newUsers: [User] = []
    @State private var someUsers: [User] = []
    @State private var searchText = ""
    @State private var searchDatabaseText = ""
    
    
    
    var usernameSearchResults: [User] {
        guard !searchText.isEmpty else { return someUsers }
        return someUsers.filter { user in
            if let username = user.username {
                return username.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                        refresh.toggle()
                    } label: {
                        Text("Cancel")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemRed))
                    }
                    
                    Spacer()
                    
                    Text("ADD USERS")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Spacer()
                    
                    if !newUsers.isEmpty {
                        Button {
                            Task {
                                try await MessageService.addUsersToGroupChat(usersToAdd: newUsers, thread: thread)
                                dismiss()
                                refresh.toggle()
                            }
                        } label: {
                            Text("Add")
                                .font(.footnote)
                                .foregroundStyle(Color(.systemBlue))
                        }
                    }
                }
                .padding(.horizontal)
                
                
                if !newUsers.isEmpty {
                    HStack {
                        Text("Add:")
                            .padding(.horizontal, 5)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .font(.footnote)
                            .fontWeight(.bold)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(Array(newUsers.enumerated()), id: \.0) { index, user in
                                    Button {
                                        newUsers.remove(at: index)
                                    } label: {
                                        CreateMessageUserCell(user: user)
                                            .padding(5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 2.5)
                                                    .stroke(Color(.systemBlue), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                        .frame(height: 30)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                }
                
                
                HStack {
                    
                    TextField("Add Users", text: $searchText, axis: .vertical)
                        .autocapitalization(.none)
                        .font(.footnote)
                        
                    Spacer()
                
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 10)
                
                ForEach(usernameSearchResults, id: \.id) { searchUser in
                    if !receivingUsers.contains(where: { $0.id == searchUser.id }) {
                        if !newUsers.contains(where: { $0.id == searchUser.id }) {
                            if searchUser.id != user.id {
                                Button {
                                    if newUsers.count + receivingUsers.count < 49 {
                                        newUsers.append(searchUser)
                                        searchText = ""
                                    }
                                } label: {
                                    VStack {
                                        CreateMessageUserCell(user: searchUser)
                                        Divider()
                                            .frame(height: 1)
                                    }
                                }
                            }
                        }
                        
                    }
                }
                Spacer()
            }
            .onChange(of: searchText) {
                if searchText.count < 1 {
                    searchDatabaseText = ""
                } else if searchText.count >= 1 {
                    searchDatabaseText = String(searchText.prefix(2))
                }
                
            }
            .onChange(of: searchDatabaseText) {
                if !searchDatabaseText.isEmpty {
                    if Checks.isValidSearch(searchDatabaseText) {
                        Task {
                            someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                        }
                    }
                }
            }
        }
    }
}
