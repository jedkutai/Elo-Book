//
//  StandardMessageBubble.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct StandardMessageBubble: View {
    @Binding var message: Message
    @Binding var messageUser: User
    @Binding var user: User
    
    private let messageWidth = UIScreen.main.bounds.width * 0.7
    private let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        if user.id == messageUser.id {
            
            HStack {
                Spacer()
                
                VStack {
                    if !message.imageUrls.isEmpty {
                        MessageImageView(imageUrls: message.imageUrls)
                    }
                    
                    Text("\(message.caption)")
                        .foregroundStyle(Color(.white))
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(.systemBlue))
                        )
                }
            }
            
        } else {
            HStack {
                
                VStack {
                    if !message.imageUrls.isEmpty {
                        MessageImageView(imageUrls: message.imageUrls)
                    }
                    
                    Text("\(message.caption)")
                        .foregroundStyle(Color(.black))
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(.gray).opacity(0.15))
                        )
                }
                
                Spacer()
            }
                
        }
            
    }
}
