//
//  CreateNewMessageViewSearchResults.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct CreateNewMessageViewSearchResults: View {
    @Binding var user: User
    @Binding var filteredUsers: [User]
    @Binding var receivingUsers: [User] 
    @Binding var searchText: String
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ForEach(filteredUsers, id: \.id) { filteredUser in
                if filteredUser.id != user.id {
                    if !receivingUsers.contains(where: { $0.id == filteredUser.id }) {
                        Button {
                            if receivingUsers.count < 48 { // max group members is 50, 48 plus you is 49 plus next person to add is 50
                                receivingUsers.append(filteredUser)
                                searchText = ""
                            }
                        } label: {
                            VStack {
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
                                        BadgeDiplayer(badge: displayedBadge)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                
                                Divider()
                                    .frame(height: 1)
                            }
                        }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .padding(.horizontal, 10)
    }
}

