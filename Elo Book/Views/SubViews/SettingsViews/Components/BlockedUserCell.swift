//
//  BlockedUserCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/23/24.
//

import SwiftUI

struct BlockedUserCell: View {
    @State var user: User
    @State var blockedUserId: String
    
    @State private var blockedUser: User?
    @State private var failed = false
    @State private var unblockAlert = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var x: X
    var body: some View {
        if failed {
            
        } else {
            VStack {
                if let blockedUser = blockedUser {
                    HStack {
                        NavigationLink {
                            AltUserProfileView(user: user, viewedUser: blockedUser)
                        } label: {
                            HStack {
                                SquareProfilePicture(user: blockedUser, size: .xSmall)
                                
                                if let fullname = blockedUser.fullname {
                                    Text("\(fullname)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                }
                                
                                if let username = blockedUser.username {
                                    Text("\(username)")
                                        .foregroundColor(Color(.systemGray))
                                }
                                
                                if let displayedBadege = blockedUser.displayedBadge {
                                    BadgeDiplayer(badge: displayedBadege)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            unblockAlert.toggle()
                        } label: {
                            Text("Unblock")
                                .foregroundStyle(Color(.systemRed))
                        }
                        
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $unblockAlert) {
                        Alert(
                            title: Text("Unblock User"),
                            message: Text("Are you sure that you want to unblock this user?"),
                            primaryButton: .destructive(Text("Unblock")) {
                                // block user
                                Task {
                                    try await UserService.unblockUser(user: user, userToUnBlock: blockedUser)
                                    
                                    x.blocked = try await FetchService.fectchBlocksViaUserId(userId: user.id)
                                    
                                }
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )

                    }
                    
                    Divider()
                }
            }
            .onAppear {
                Task {
                    do {
                        blockedUser = try await FetchService.fetchUserById(withUid: blockedUserId)
                        if blockedUser == nil {
                            failed = true
                        }
                    } catch {
                        failed = true
                    }
                }
            }
            
        }
    }
}


