//
//  CreateNewMessageViewReceivingUsers.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct CreateNewMessageViewReceivingUsers: View {
    @Binding var receivingUsers: [User]
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if !receivingUsers.isEmpty {
            HStack {
                HStack {
                    Text("To:")
                        .padding(.horizontal, 5)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .font(.footnote)
                        .fontWeight(.bold)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(Array(receivingUsers.enumerated()), id: \.0) { index, receivingUser in
                            Button {
                                receivingUsers.remove(at: index)
                                
                            } label: {
                                if index > 0 {
                                    Text(",")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                }
                                
                                HStack {
                                    
                                    SquareProfilePicture(user: receivingUser, size: .xSmall)
                                    
                                    if let fullname = receivingUser.fullname {
                                        Text("\(fullname)")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    }
                                    
                                    if let username = receivingUser.username {
                                        Text("\(username)")
                                            .font(.footnote)
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                    
                                    if let displayedBadge = receivingUser.displayedBadge {
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
    
    }
}
