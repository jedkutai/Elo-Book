//
//  EmptyFeedUserCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 1/3/24.
//

import SwiftUI

struct EmptyFeedUserCell: View {
    @State var user: User
    @State var viewedUser: User
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @State private var followCooldown = false
    @State private var following = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if self.hidden {
                
            } else {
                VStack {
                    SquareProfilePicture(user: viewedUser, size: .xxLarge)
                    
                    if let fullname = viewedUser.fullname {
                        Text(fullname)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    } else {
                        Text("")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    HStack {
                        if let username = viewedUser.username {
                            Text(username)
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray))
                        }
                        
                        if let displayedBadge = viewedUser.displayedBadge {
                            BadgeDisplayer(badge: displayedBadge)
                        }
                    }
                    
                    if following {
                        Button {
                            if !followCooldown {
                                followCooldown.toggle()
                                Task {
                                    try await UserService.unFollowUser(userId: user.id, userToUnfollow: viewedUser.id)
                                    following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                                    followCooldown.toggle()
                                }
                            }
                        } label: {
                            Text("Following")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .frame(height: 20)
                                .background(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6)
                                    .stroke(.gray, lineWidth: 1))
                        }
                    } else {
                        Button {
                            if !followCooldown {
                                followCooldown.toggle()
                                Task {
                                    try await UserService.followUser(userId: user.id, userToFollowId: viewedUser.id)
                                    following = try await FetchService.userAFollowingUserB(userAId: user.id, userBId: viewedUser.id)
                                    followCooldown.toggle()
                                }
                            }
                        } label: {
                            Text("Follow")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .frame(height: 20)
                                .background(Color(.systemBlue))
                                .foregroundStyle(Color(.white))
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6)
                                    .stroke(.clear, lineWidth: 1))
                        }
                    }
                    
                    
                }
                .padding(.top, 3)
                .frame(width: 150)
                .onAppear {
                    let blockedByUser = x.blockedBy.contains { block in
                        return block.userId == viewedUser.id
                    }
                    
                    let blockedUser = x.blocked.contains { block in
                        return block.userToBlockId == viewedUser.id
                    }
                    
                    self.hidden = blockedByUser || blockedUser
                }
            }
        }
    }
}
