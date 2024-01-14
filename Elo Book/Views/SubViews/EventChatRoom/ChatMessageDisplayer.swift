//
//  ChatMessageDisplayer.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

import SwiftUI

struct ChatMessageDisplayer: View {
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
                                BadgeDiplayer(badge: displayedBadge)
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
                                            .foregroundStyle(Color(.systemGray).opacity(0.3))
                                    )
                                
                                Spacer()
                            }
                        }
                        
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
