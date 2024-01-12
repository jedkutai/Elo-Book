//
//  StandardGroupMessageBubble.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct StandardGroupMessageBubble: View {
    @Binding var message: Message
    @Binding var messageUser: User
    @Binding var user: User
    @Binding var messageSetting: GroupMessageSettings
    
    private let messageWidth = UIScreen.main.bounds.width * 0.7
    private let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        if user.id == messageUser.id {
            
            HStack {
                Spacer()
                
                VStack {
                    
                    if !message.imageUrls.isEmpty {
                        HStack {
                            Spacer()
                            StaticPostImageView(imageUrls: message.imageUrls)
                        }
                    }
                    
                    if !message.caption.isEmpty {
                        HStack {
                            Spacer()
                            Text("\(message.caption)")
                                .foregroundStyle(Color(.white))
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color(.systemBlue))
                                )
                        }
                    }
                }
                
            }
            
        } else {
            HStack {
                VStack {
                    Spacer()
                    if messageSetting.showProfileImage {
                        SquareProfilePicture(user: messageUser, size: .xSmall)
                    }
                }
                .frame(width: 22)
                
                VStack {
                    if messageSetting.showUsername {
                        HStack {
                            if let username = messageUser.username {
                                Text("\(username)")
                                    .font(.footnote)
                                    .foregroundStyle(Color(.systemGray))
                            }
                            
                            if let displayedBadge = messageUser.displayedBadge {
                                BadgeDiplayer(badge: displayedBadge)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                    }
                    if !message.imageUrls.isEmpty {
                        HStack {
                            StaticPostImageView(imageUrls: message.imageUrls)
                            Spacer()
                        }
                    }
                    
                    if !message.caption.isEmpty {
                        HStack {
                            Text("\(message.caption)")
                                .foregroundStyle(Color(.black))
                                .padding(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color(.lightGray))
                                )
                            Spacer()
                        }
                        .padding(0)
                    }
                }
                
                Spacer()
            }
                
        }
            
    }
}
