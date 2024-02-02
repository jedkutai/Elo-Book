//
//  MessageDisplayer.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import SwiftUI

struct MessageDisplayer: View {
    @State var user: User
    @State var messageUser: User
    @State var message: Message2
    @State var messageInfo: MessageInfo
    @State var isGroupMessage: Bool
    
    
    @Environment(\.colorScheme) var colorScheme
    private let maxWidth = UIScreen.main.bounds.width * 0.7
    var body: some View {
        Group {
            if messageInfo.showTime {
                Text("\(DateFormatter.longDate(timestamp: message.timestamp))")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
            }
            if user.id == messageUser.id {
                HStack {
                    Spacer()
                    if let caption = message.caption {
                        Text(caption)
                            .foregroundStyle(Color(.white))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .foregroundStyle(Color(.systemBlue))
                            )
                    } else if let sharedUserId = message.sharedUserId {
                        StaticUserProfileLoader(user: user, viewedUserId: sharedUserId)
                    } else if let sharedPostId = message.sharedPostId {
                        StaticPostLoader(user: user, postId: sharedPostId)
                    } else if let imageUrls = message.imageUrls {
                        MessageImageView(imageUrls: imageUrls)
                    }
                }
            } else {
                if isGroupMessage {
                    if messageInfo.showName {
                        HStack {
                            if let fullname = messageUser.fullname {
                                Text(fullname)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            }
                            
                            if let username = messageUser.username {
                                Text(username)
                                    .font(.footnote)
                                    .foregroundStyle(Color(.systemGray))
                            }
                            
                            if let displayedBadge = messageUser.displayedBadge {
                                BadgeDisplayer(badge: displayedBadge)
                            }
                            Spacer()
                        }
                        .frame(height: 30)
                        .padding(.bottom, 0)
                        .padding(.leading, 35)
                        
                    }
                }
                HStack {
                    if isGroupMessage {
                        VStack {
                            Spacer()
                            if messageInfo.showIcon {
                                SquareProfilePicture(user: messageUser, size: .xSmall)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(Color(.clear))
                                    .frame(width: 20)
                            }
                            
                        }
                        .padding(.bottom, 10)
                        
                    }
                    
                    if let caption = message.caption {
                        VStack {
                            
                            HStack {
                                Text(caption)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .foregroundStyle(Color(.systemGray).opacity(0.2))
                                    )
                                
                                Spacer()
                            }
                        }
                        
                    } else if let sharedUserId = message.sharedUserId {
                        StaticUserProfileLoader(user: user, viewedUserId: sharedUserId)
                    } else if let sharedPostId = message.sharedPostId {
                        StaticPostLoader(user: user, postId: sharedPostId)
                    } else if let imageUrls = message.imageUrls {
                        MessageImageView(imageUrls: imageUrls)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            if let seenBy = message.messageSeenBy {
                if !seenBy.contains(user.id) {
                    Task {
                        // add userid to seenby
                        try await MessageService.messageSeenByUser(user: user, message: message)
                    }
                }
            }
        }
    }
}
