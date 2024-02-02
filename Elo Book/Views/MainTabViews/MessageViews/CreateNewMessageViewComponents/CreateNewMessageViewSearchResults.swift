//
//  CreateNewMessageViewSearchResults.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct CreateNewMessageViewSearchResults: View {
    @Binding var user: User
    @Binding var receivingUsers: [User] 
    @Binding var searchText: String
    
    @State private var followers: [User] = []
    var filteredUsers: [User] {
        guard !searchText.isEmpty else { return [] }
        return followers.filter { searchUser in
            if user.id == searchUser.id {
                return false
            }
            
            if receivingUsers.contains(where: { $0.id == searchUser.id }) {
                return false
            }
            
            if let username = searchUser.username {
                return username.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(filteredUsers, id: \.id) { filteredUser in
                    if filteredUser.id != user.id {
                        if !receivingUsers.contains(where: { $0.id == filteredUser.id }) {
                            Button {
                                if receivingUsers.count < 48 { // max group members is 50, 48 plus you is 49 plus next person to add is 50
                                    receivingUsers.append(filteredUser)
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
            .scrollDismissesKeyboard(.interactively)
            .padding(.horizontal, 10)
        }
        .onAppear {
            Task {
                followers = try await FetchService.fetchFollowersByUser(user: user)
            }
        }
    }
}

